#!/usr/bin/env python3

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

REMOTE_EXPRESSION = "luaeval('require(\"user.lib.scratch\").run_agent_request(_A)', %s)"
CLIENT_ERROR = 3
CONFLICT = 4
NOT_FOUND = 5


class ScratchClientError(Exception):
    pass


def positive_int(value):
    count = int(value)
    if count < 1:
        raise argparse.ArgumentTypeError("count must be positive")
    return count


def add_context_argument(parser):
    parser.add_argument("--cwd", default=os.getcwd(), help="scratch project directory")


def add_identity_arguments(parser):
    parser.add_argument("--name", required=True, help="scratch name")
    parser.add_argument("--ft", default="markdown", help="scratch filetype")
    parser.add_argument("--count", type=positive_int, default=1, help="scratch number")
    add_context_argument(parser)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Read and write project-scoped Snacks scratches"
    )
    commands = parser.add_subparsers(dest="command", required=True)

    list_parser = commands.add_parser(
        "list", help="list scratches in the current project context"
    )
    add_context_argument(list_parser)

    read_parser = commands.add_parser("read", help="read a saved or loaded scratch")
    add_identity_arguments(read_parser)

    write_parser = commands.add_parser("write", help="create or replace a scratch")
    add_identity_arguments(write_parser)
    write_parser.add_argument(
        "--file", type=Path, help="read content from this file instead of stdin"
    )
    write_parser.add_argument(
        "--force", action="store_true", help="replace a modified scratch buffer"
    )
    return parser.parse_args()


def load_content(args):
    if args.file:
        try:
            return args.file.read_text(encoding="utf-8")
        except OSError as error:
            raise ScratchClientError(f"cannot read scratch input: {error}") from error
    return sys.stdin.read()


def build_request(args):
    request = {
        "op": args.command,
        "cwd": os.path.abspath(args.cwd),
    }
    if args.command != "list":
        request.update(name=args.name, ft=args.ft, count=args.count)
    if args.command == "write":
        request.update(content=load_content(args), force=args.force)
    return request


def send_request(request):
    server = os.environ.get("NVIM")
    nvim = shutil.which("nvim")
    if not server:
        raise ScratchClientError(
            "NVIM is not set; run this from a Neovim-hosted Codex session"
        )
    if not nvim:
        raise ScratchClientError("nvim is not available on PATH")

    request_path = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            prefix="codex-scratch-",
            suffix=".json",
            delete=False,
        ) as request_file:
            json.dump(request, request_file, ensure_ascii=False)
            request_path = request_file.name

        expression = REMOTE_EXPRESSION % json.dumps(request_path)
        result = subprocess.run(
            [nvim, "--server", server, "--remote-expr", expression],
            capture_output=True,
            text=True,
            timeout=15,
            check=False,
        )
    except subprocess.TimeoutExpired as error:
        raise ScratchClientError(
            "Neovim did not answer the scratch request within 15 seconds"
        ) from error
    finally:
        if request_path:
            Path(request_path).unlink(missing_ok=True)

    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip() or "unknown RPC error"
        raise ScratchClientError(f"Neovim scratch request failed: {detail}")
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as error:
        raise ScratchClientError(
            "Neovim returned an invalid scratch response"
        ) from error


def print_response(args, response):
    status = response.get("status")
    if status in {"error", "conflict", "not_found"}:
        print(json.dumps(response, ensure_ascii=False), file=sys.stderr)
        return {"conflict": CONFLICT, "not_found": NOT_FOUND}.get(status, 1)
    if args.command == "read":
        sys.stdout.write(response["content"])
    elif args.command == "list":
        print(json.dumps(response["items"], ensure_ascii=False))
    else:
        print(json.dumps(response, ensure_ascii=False))
    return 0


def main():
    args = parse_args()
    try:
        return print_response(args, send_request(build_request(args)))
    except (OSError, ScratchClientError, ValueError) as error:
        print(f"codex-scratch: {error}", file=sys.stderr)
        return CLIENT_ERROR


if __name__ == "__main__":
    raise SystemExit(main())
