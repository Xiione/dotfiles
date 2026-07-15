import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

sys.path.insert(0, str(Path(__file__).parents[1] / "scripts"))
import scratch


class ScratchRendezvousTest(unittest.TestCase):
    session = "codex 0123456789a"

    def environment(self, state_home, **overrides):
        environment = {
            "XDG_STATE_HOME": state_home,
            "NVIM_APPNAME": "nvim-test",
            "ZELLIJ_SESSION_NAME": self.session,
        }
        environment.update(overrides)
        return environment

    def write_rendezvous(self, state_home, **overrides):
        rendezvous = {
            "version": 1,
            "session": self.session,
            "server": "/tmp/current-nvim",
            "pid": 123,
            "cwd": "/tmp/project",
        }
        rendezvous.update(overrides)
        path = (
            Path(state_home)
            / "nvim-test"
            / "sidekick"
            / "rendezvous"
            / f"{self.session}.json"
        )
        path.parent.mkdir(parents=True)
        path.write_text(json.dumps(rendezvous), encoding="utf-8")
        return path

    def test_uses_rendezvous_when_inherited_server_is_missing(self):
        with tempfile.TemporaryDirectory() as state_home:
            self.write_rendezvous(state_home)
            with mock.patch.dict(os.environ, self.environment(state_home), clear=True):
                self.assertEqual(
                    scratch.server_candidates(),
                    [("the Sidekick rendezvous", "/tmp/current-nvim")],
                )

    def test_ignores_invalid_rendezvous(self):
        with tempfile.TemporaryDirectory() as state_home:
            self.write_rendezvous(state_home, session="codex wrong")
            with mock.patch.dict(os.environ, self.environment(state_home), clear=True):
                self.assertEqual(scratch.server_candidates(), [])

    def test_deduplicates_matching_inherited_server(self):
        with tempfile.TemporaryDirectory() as state_home:
            self.write_rendezvous(state_home)
            environment = self.environment(state_home, NVIM="/tmp/current-nvim")
            with mock.patch.dict(os.environ, environment, clear=True):
                self.assertEqual(
                    scratch.server_candidates(), [("$NVIM", "/tmp/current-nvim")]
                )

    def test_retries_stale_inherited_server_through_rendezvous(self):
        with tempfile.TemporaryDirectory() as state_home:
            self.write_rendezvous(state_home)
            environment = self.environment(state_home, NVIM="/tmp/stale-nvim")
            stale = subprocess.CompletedProcess(
                args=[], returncode=1, stdout="", stderr="connection refused"
            )
            live = subprocess.CompletedProcess(
                args=[], returncode=0, stdout='{"status":"ok","items":[]}', stderr=""
            )
            with (
                mock.patch.dict(os.environ, environment, clear=True),
                mock.patch.object(
                    scratch.shutil, "which", return_value="/usr/bin/nvim"
                ),
                mock.patch.object(
                    scratch.subprocess, "run", side_effect=[stale, live]
                ) as run,
            ):
                response = scratch.send_request({"op": "list", "cwd": "/tmp/project"})

            self.assertEqual(response, {"status": "ok", "items": []})
            self.assertEqual(run.call_count, 2)
            self.assertEqual(run.call_args_list[0].args[0][2], "/tmp/stale-nvim")
            self.assertEqual(run.call_args_list[1].args[0][2], "/tmp/current-nvim")


if __name__ == "__main__":
    unittest.main()
