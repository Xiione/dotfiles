local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠆⠀⠀⠀⠀⠄⠀⠈⢀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⢀⢀⠀⠀⠀⠈⠀⢀⡰⣊⢤⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠠⠠⠈⠂⠁⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⣍⠄⡂⡺⡀⡰⢄⡀⣔⡲⢞⡩⢥⡰⠂⠀⠀⠀⢀⢀⠒⡤⠜⠠⢔⣈⠣⠄⡀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⣀⣀⣀⣤⣀⡀⠀⠀⠀⠀⠹⠞⡾⠀⠀⠀⡝⢦⡙⡵⣀⠦⣑⢫⡏⣴⣣⡜⠔⠁⡢⢉⣴⡋⢄⠢⡜⣢⠳⠔⠃⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣬⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⢨⢟⡄⢸⢀⡗⣩⢶⣒⢦⣙⣮⠵⢫⡜⢧⢒⠐⣀⠀⣆⡲⡎⠸⡞⣋⣙⠃⠒⣲⠄⠂]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⣯⢷⠀⠸⠜⠑⠉⠁⠀⠒⠂⠒⠂⠐⢸⡌⠳⢤⡹⠐⠴⠠⢁⡐⣠⠤⢤⣊⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⡭⠑⠀⠀⠁⠂⢀⠀⠀⠀⠀⠀⠀⠀⢳⡍⡖⣝⢪⡡⠄⠜⠘⠡⢒⢀⣀⢏⡫⠭]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⢀⢂⠈⠉⠛⠛⠛⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⣁⡄⠀⠀⠈⡄⠀⡀⠀⠂⠠⠀⠀⠀⠀⠀⠹⣜⢆⣳⡥⡌⠃⡴⣠⠎⢙⠁⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢹⡏⣿⡟⡏⢿⡿⣿⣿⢢⢀⠆⢀⡇⠀⢹⣈⠐⠀⠠⠄⢁⣂⣐⠂⠈⣳⢧⡘⢝⡦⡀⢡⠀⠄⢀⠉⠢⡀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⡿⡁⡾⢠⣿⠳⣇⠈⣇⣹⡏⠆⣾⢃⠞⠼⡀⠸⣇⣆⠰⣢⢀⠀⡈⡀⠠⠐⠙⢫⣵⡰⡝⠻⡦⣔⠀⠠⠀⠀⠈]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠐⣹⣿⣿⣿⣿⣿⣿⣿⢏⣴⣿⡛⠃⢄⠋⠸⢱⣿⡍⠹⢻⢠⠻⡶⣄⠈⢇⠰⠌⢮⡉⠻⣧⡐⠠⠏⠤⣀⠀⠘⣽⣵⡐⡀⠊⠹⠫⣒⠤⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⠻⣿⣿⣿⣿⡄⠟⠿⠧⠁⠀⠀⠀⠈⠿⠃⠀⣟⣸⠸⢰⣟⠀⢘⠤⠀⢶⠿⣤⡻⣧⡁⣟⠰⣀⠣⣬⣘⣯⠣⡘⡀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣯⣙⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⢀⡿⢿⠀⠈⠂⠀⠀⠘⠀⠁⣶⣿⣧⠳⣷⢸⡐⣦⡿⣳⡫⠂⠀⠈⠢⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⣀⡀⠐⠀⠀⢀⣴⣿⠃⢸⡀⠀⠐⠀⠀⠀⠀⠉⢯⡽⠁⠜⡜⠳⡜⢆⡿⠕⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣂⠤⠀⣀⣤⣾⣿⡿⣟⣤⠀⣛⡦⡈⠂⡀⣀⠀⠀⠀⢀⣌⠞⣈⠽⡀⠑⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⠿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠇⢁⡡⠀⠘⡅⠡⠤⠤⢀⡀⠀⢤⡮⢒⣴⣭⣶⡶⣾⣞⠯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⢏⡳⣙⠮⡜⡻⢿⣿⣿⣿⣿⣿⡟⢣⠀⠀⡁⢶⠀⠀⠀⠄⢀⠨⠻⢿⡫⠔⠁⠀⠙⠿⣦⣄⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⢏⡚⡴⡩⢖⠭⣓⢭⣛⣿⣿⣿⡟⢠⢨⠀⠌⢡⢰⡦⠀⠄⠀⢃⢠⠂⠃⠀⠀⠀⠀⠀⠐⡀⠉⠋⠞⡉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣟⣮⣟⠭⣓⠯⣞⡡⢖⠦⣙⣿⣿⡇⠸⠀⠀⠀⠆⢸⡡⠂⣀⢢⡿⠋⡈⠂⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⣴⣿⣿⠿⠋⢡⣿⣿⣿⣿⣿⣿⣿⣿⠄⠀⢛⡲⢝⡺⢥⣣⣾⣿⠁⠀⠀⠀⠀⢠⠃⡎⣫⠡⣱⠠⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠛⠉⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠙⣄⠙⡳⢏⣾⡿⡀⠀⠀⢀⣶⠝⠈⠭⠁⠀⡱⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠠⠀⠠⠕⢥⢀⣼⣷⣿⣷⠎⠉⠀⠀⠈⠁⠀⡴⠃⢀⡀⢽⣶⣶⣬⣡⡄⣢⠹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⠀⠑⠢⠠⢂⣽⣿⣿⣿⣿⠀⠀⠀⠀⠰⡰⠈⢼⡉⡗⠀⠀⢂⠉⠉⠙⢉⣀⠁⢂⠄⢀⡀⠀⠀⢀⢀⡤⠦⠠⠓⠒⢶⡖]],
	-- [[⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡔⠀⢀⢪⡔⢸⣿⣿⣿⣿⡄⡣⠀⠀⠀⡆⠛⢧⡜⡙⡟⡦⠀⠀⣠⣄⣀⣰⡾⠝⣠⡞⠍⠋⠄⠐⠀⠀⠀⠀⠀⠈⠐⣳]],
	-- [[⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠃⡎⠄⡾⠋⢻⣿⣿⣷⢺⡘⡆⢂⠁⠀⠀⠑⠵⠁⠘⠻⢛⠳⡩⢍⣹⠀⡰⠋⠀⠁⠀⠀⠀⠀⠀⠀⠀⣀⣴⠟⠁]],
	-- [[⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡯⠐⡐⠀⠘⠁⠀⠀⠻⣿⡟⠂⡐⢨⡑⢄⠀⠀⠀⠀⠀⠀⢀⠎⡵⢱⠊⠀⢈⢂⠀⠀⢀⠠⢂⢌⢂⣦⣵⡿⠟⠓⠈⠁]],
	-- [[⡿⠟⣰⣿⣿⣿⣿⣿⣿⣿⡿⠿⣛⢋⣁⣀⣀⠀⠇⠀⠀⠀⠀⠀⠄⠈⢀⠄⡧⠸⠐⠁⠀⠄⠀⠀⠀⢀⢎⡚⡔⢋⡞⣍⠫⡜⢭⠲⣅⣫⣼⣾⡿⠋⠁⠀⠀⠀⠀⠀]],
	-- [[⠀⢠⣿⣿⣿⣿⣿⣿⢿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⢀⡇⠠⠈⡆⠀⠀⠠⣒⡤⣃⠎⡴⠋⢸⠜⣰⢋⡜⡆⣏⠼⡍⠥⠍⠈⠙⡒⠶⣤⣀⠀⠀]],
	-- [[⠀⣿⣿⣿⠿⡻⢵⡚⢯⠭⣭⠹⣌⡲⣳⣵⣿⣿⣿⣿⡄⠀⠀⠀⠀⠂⣁⢲⣷⡄⠁⣷⡄⠀⠀⠠⣻⡔⣩⠁⠀⣨⢻⢏⡚⡴⣩⢆⡳⡼⠀⠀⠀⠀⠀⠀⠐⠈⡓⣦]],
	-- [[⡰⡿⢓⡕⢮⡱⢣⡝⡬⢳⡤⣓⠵⣩⢓⡬⡝⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⢹⣿⣿⡄⢸⣿⣆⠀⠠⠢⣻⢴⡒⢶⣫⣝⣾⡻⣝⣣⢾⣹⢏⡝⠁⠀⠀⠀⠀⠀⠀⠀⠈]],
	-- [[⠋⡴⡹⣜⢣⡝⣣⢜⠵⡉⣤⠓⣮⢱⡩⢖⡩⢞⣿⣿⣿⣧⠀⠀⠀⠀⠀⣿⣿⣿⣿⡄⢿⡿⢂⢴⡹⢥⢣⡟⣻⠱⣎⢿⢯⣛⠛⠮⠵⠫⠵⡉⠄⣀⠀⡀⢀⠀⡈⠤]],
	-- [[⡝⣲⠱⣎⠳⣜⠕⣁⠲⣍⠶⣙⠴⢣⡱⢫⡔⣻⡿⣿⣿⣿⣆⠀⠀⠀⢠⣿⣿⣿⣿⣿⠊⠀⠀⠣⡓⢎⡣⢞⣡⠳⣘⢾⡻⣌⠳⣕⠨⡑⢢⠑⡌⢄⣣⣌⣢⡼⠶⠛]],
	-- [[⠈⠥⢟⣬⣓⠁⣴⢩⠳⣌⠳⡥⡛⣆⢳⠱⢼⡿⢲⡹⣿⣿⣿⡄⠀⠀⣸⣿⣿⣿⣿⠁⠀⠀⠀⢀⡌⠣⣓⠮⡔⣫⢜⠃⢱⣊⢷⠜⠻⡛⠚⠛⠛⠛⠉⠉⠁⠀⠀⠀]],
	-- [[⢀⣾⣅⠀⠀⠀⡱⣍⠳⣌⢳⡑⡳⣌⢇⣫⣿⡓⢧⡱⡹⣿⣿⣷⡀⠀⣿⣿⣿⣿⠇⠀⠀⠀⢠⡼⣣⠀⠀⠙⠓⢥⠏⠀⠀⢳⡞⠀⠀⠈⠢⠐⠄⠀⠀⠀⠀⠀⠀⠀]],
	-- [[⣿⣿⣿⣷⢠⠋⢀⡏⠑⠎⣧⡙⡖⣥⢚⣼⡯⢜⢥⢣⢓⡏⢿⣿⣧⢠⣿⣿⣿⡏⠀⠀⠀⣠⠟⢠⠹⣄⠀⠀⠀⠀⠀⠀⠀⠈⣧⠀⠀⠀⠀⠀⠀⠑⡄⠀⠀⠀⠀⠀]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠙⢻⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⠋⠀⠀ ⠀⠀⠀ ⠀⠀⠹⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿]],
	-- [[⣿⣿⠁⠀⠀⠀⠀⠀⠀⣠⡀⠀⠀⠀⠀⠀⠘⣿⣿⣿]],
	-- [[⣿⡏⠀⠀⠀⠀⠀⠀⣼⣿⣷⡄⠀⠀⠀⠀⠀⢹⣿⣿]],
	-- [[⣿⠃⠀⠀⠀⠀⠀⢰⣿⣿⣿⣧⠀⠀⠀⠀⠀⢸⣿⣿]],
	-- [[⣿⠀⠀⠀⠀⠀⠀⢸⡟⠉⠙⢿⠀⠀⠀⠀⠀⠀⣿⣿]],
	-- [[⣿⠀⠀⠀⠀⠀⠀⢸⣇⣀⣠⣿⠀⠀⠀⠀⠀⠀⢻⣿]],
	-- [[⣿⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⢸⣿]],
	-- [[⣿⠀⠀⠀⠀⠀⠀⠀⠈⣿⡿⠀⠀⠀⠀⠀⠀⠀⢸⣿]],
	-- [[⣿⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⢸⣿]],
	-- [[⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿]],
	-- [[⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿]],
	-- [[⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⣿]],
	-- [[⣿⠀⠀⠀⠀⣰⡄⠀⠀⠀⠀⠀⠀⠀⢠⡆⠀⠀⠀⣿]],
	-- [[⣿⠀⠀⠀⢀⣿⡇⠀⠀⠀⠀⠀⠀⠀⣼⣿⠀⠀⠀⣿]],
	-- [[⣿⠀⠀⠀⣸⣿⡇⠀⠀⠀⠀⠀⠀⠀⣿⣿⡄⠀⠀⣿]],
	-- [[⣿⡆⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⢠⣿⣿⣷⡀⠰⣿]],
	-- [[⣿⡇⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡇⢘⣿]],
	-- [[⣿⣇⠀⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣾⣿]],
	-- [[⣿⣿⣼⣿⣿⣿⣿⡇⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⣽⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	-- [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿]]
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⣻⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⢲⣤⡀⠀⠀⠀⠀⠀⠀⠀⢀⡴⣞⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣴⣶⣶⣶⣶⣶⣤⣤⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣯⠞⠁⣿⡇⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣸⡇⢿⠙⢿⣷⣄⡀⠀⠀⠀⣰⢋⡴⠋⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⡲⢤⡀⠀⠀⣼⣹⠃⠀⠀⣿⣧⣀⣠⠤⠖⠒⠋⠉⠉⠉⠉⠉⣇⢸⠓⠲⠬⣿⣿⣦⢀⡾⣡⠏⠀⠀⣸⣿⠁⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣝⣶⣴⣷⣧⣤⠔⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡜⡇⠀⠀⠈⣹⠛⠛⠻⣍⠙⠲⣤⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡇⡇⠀⠀⣠⡇⡄⢦⡀⠀⠁⠀⢀⡉⠳⢤⣀⡀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣇⣠⣾⡿⡇⢣⠘⢿⣦⡤⠖⣩⠞⠙⢶⣬⣉⣓⠦⢤⣀⣀]],
[[⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠛⠛⠛⠛⠛⠛⠛⠛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠷⠿⠟⠉⠀⣇⠈⠉⠉⡻⡓⢮⡑⣦⡀⠀⠙⢯⠉⠉⠉⠉⠉]],
[[⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡀⡔⠋⠀⠙⢦⣙⠺⣍⠓⢦⣄⡳⣄⠀⠀⠀]],
[[⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⣀⣠⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣄⡀⠀⠈⢻⣿⣿⣿⣿⡀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡄⠀⠀⠈⡇⢹⠀⠀⠀⢶⡈⠛⠪⣽⣶⣤⣉⠛⢧⡀⠀]],
[[⠀⠀⠀⠀⣿⣿⣿⣿⣿⢹⣿⣿⣿⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⡄⠀⣿⣿⣿⣿⡇⠀⠀⣷⠀⠀⠀⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡄⠀⠀⢸⣸⠀⠀⠀⠘⡿⢦⡀⠹⡄⠙⠿⣿⣅⠙⢦]],
[[⠀⠀⠀⠀⣿⣿⣿⣿⡟⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⣿⣿⣿⣿⣿⠀⢰⣿⠀⠀⠀⢹⣿⡄⠀⠀⠀⠀⢻⣦⡀⠀⠀⢀⣷⠀⠀⠀⢿⢼⠀⠀⠀⢻⠀⠑⢦⡹⣆⠀⠹⣿⠳⢦]],
[[⠀⠀⠀⠀⣿⣿⣿⣿⢣⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⣿⠃⣿⣿⣿⠇⣿⠉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣇⢸⠀⠘⣿⣿⢦⡀⣄⠀⠀⢹⣿⣦⡀⠀⢿⣇⠀⠀⢸⣿⠀⠀⣦⠘⡇⠀⠀⢹⠾⠆⠀⢹⡆⠀]],
[[⠀⠀⠀⠀⢹⣿⣿⡟⢸⣿⣿⣿⣿⡟⢹⣿⣿⡿⠛⣾⠛⢺⣿⣿⠏⢠⡟⠀⠘⣿⣿⣏⣻⣿⣿⣿⣿⣿⣿⣿⢹⣧⣼⣿⠹⣼⣷⣧⡸⣿⡄⠙⠾⣷⣟⠉⢻⡿⣿⣦⣼⣿⠀⠀⢸⣿⡀⠀⣿⡆⢹⡀⠀⠘⣧⠀⠀⠀⢻⡀]],
[[⠀⠀⠀⠀⢠⣿⣿⠇⣾⣿⣿⣿⠟⠀⣸⣿⠟⠁⡼⠁⠀⣸⣿⠏⠀⣸⠃⠀⠀⢻⣿⠏⠙⣿⣿⣿⣿⣿⣿⡏⣸⣿⣿⣿⠃⠹⣧⠹⣷⡹⣿⡀⠀⠈⠛⠷⣄⢳⠈⢻⣿⣿⠀⠀⢸⣿⣧⠀⣿⣿⡌⢧⠀⠰⣼⣷⡀⠀⠀⢳]],
[[⠀⠀⠀⠀⣾⣿⡿⠀⣿⣿⣿⡟⠀⠀⠿⠁⠀⠀⠀⠀⢀⡿⠃⠀⠀⠋⠀⠀⠀⢸⡟⠀⠀⠘⣟⣿⣿⣿⣿⠁⡏⠈⣿⣿⡇⠀⠹⣆⠈⠻⣽⣧⠀⠀⠀⠀⠈⠻⣧⠀⠙⢻⠀⠀⠀⣿⣿⣆⢸⣿⣿⣞⣇⠀⣿⣿⡝⢦⡀⠈]],
[[⠀⠀⠀⣸⣿⣿⣷⢰⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⢤⣀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⢸⠇⠀⠈⢿⠀⠀⠀⠙⠆⠀⠈⠛⢧⠀⠀⠀⠀⠀⠀⠀⠀⢸⢠⡆⠀⣿⣿⡿⣦⣧⠻⣟⢿⡆⢸⡌⢻⣄⠙⠦]],
[[⠀⠀⢠⣿⣿⡿⣼⢸⣿⣿⣿⡇⠀⠚⠉⠉⠙⠒⠢⣬⠂⠀⠀⠀⠀⠀⠀⠀⠤⣖⣂⣀⣀⡀⠀⣸⣿⣿⣿⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡖⠛⠉⠉⠉⠉⠓⢚⣾⠁⢠⣿⡿⠁⠈⢿⣆⠙⢦⡀⠀⣇⠀⠙⠦⠀]],
[[⠀⢀⣿⣿⣿⢳⣿⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠊⠁⠀⠀⠀⠉⢰⣿⣿⣿⣿⡏⠠⠖⠓⠒⠒⠦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⣿⡄⢸⣿⠀⠀⠀⠀⠙⠂⠈⠳⣄⣻⠀⠀⠀⠀]],
[[⠀⣾⣿⣿⣿⡏⢸⢸⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⢳⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢇⡇⣼⡇⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⠀⠀⠀⠀]],
[[⢸⣿⣿⢫⣿⠀⠘⣾⣿⣿⡿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⢀⣾⢫⣿⣿⣿⡄⡹⣷⡀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⣻⣧⣿⣀⡤⠖⢋⠛⢢⡄⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⣿⣿⠃⣸⠇⠀⠀⣿⣿⣿⠃⢻⣿⡏⢓⡦⣀⠀⠀⠀⢀⡀⠀⠀⢉⠀⠀⠀⠀⢀⣀⣴⣿⠃⣸⣿⣿⣿⣷⣿⡹⣧⣀⠀⠀⠀⠀⠀⠀⠘⠋⠀⠀⠀⢀⠔⠀⣀⡴⣚⣵⡿⢿⣿⣿⣹⠀⠀⠞⠀⠀⠘⢦⠀⠀⠀⠀⠀⠀⠀]],
[[⣿⠃⠀⣿⠀⠀⠀⣼⣿⣿⡄⠈⣿⣧⠀⢳⡈⠻⢶⣦⢄⣈⣁⣈⣁⣤⡴⢶⢿⣿⣩⠞⠁⢠⣿⣿⡟⢻⡆⢻⣧⠈⡏⠙⣗⠶⢤⣤⣀⣀⣀⡈⠁⣀⣠⣴⣾⣷⡿⠟⠉⢀⣿⣿⡏⠁⠀⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀⠀⠀⠀]],
[[⡏⠀⠀⡇⠀⠀⠀⢹⣿⣿⣇⠀⢸⣿⠀⣀⣹⣄⡀⠉⠳⡌⢟⡵⠊⠉⣠⣏⢸⣿⠁⠀⠀⣾⣿⣿⠁⢸⠃⡞⠙⢧⡇⠀⠈⠓⣾⣿⢹⡙⠻⢿⣛⡿⢾⠽⠋⠁⠀⢀⡴⠫⢇⣿⠃⡄⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⡃⠀⠀⠀⠈⢏⢿⣿⡖⠚⠻⣏⠉⠀⠈⠉⢓⣦⣇⣿⣠⡴⠛⠉⠉⠙⠛⠲⣤⣼⣿⣿⠃⠀⠈⢿⠃⠀⠈⠻⠀⠀⢀⣿⣏⣈⣧⣀⡀⠈⢷⣿⠀⠀⠀⣰⠋⠀⠀⢸⡿⠀⢧⠀⢠⠀⠀⠀⠀⠀⠀⠈⢧⠀⠀⠀⠀]],
[[⠀⠠⠤⢷⣄⠀⠀⠀⠘⣾⢿⣷⠀⠀⠙⠆⠀⠀⠘⠛⢹⡇⠀⡿⠻⠦⠀⠀⠀⠀⠀⢸⣿⣿⡏⠀⠀⢀⣈⣧⠀⠀⡇⢰⠛⠋⠉⠀⠀⠀⠀⣙⣷⣼⣾⣧⣴⡚⠋⠉⠉⠛⠛⠧⣤⣸⠀⡾⠀⠀⠀⠀⠀⠀⠀⠈⢦⡀⠀⠀]],
[[⠀⠀⠀⠀⠈⠳⣄⠀⠀⢸⣀⡿⣧⠀⠀⠀⠀⠀⠲⣶⣾⣧⣴⣇⣀⣤⡄⠀⠀⠀⢀⣿⣿⠋⡗⢠⡾⠛⢉⡞⠀⠀⢹⠈⣇⠀⠀⠀⠀⠀⠘⠋⢹⠇⢸⡏⠙⠛⠀⠀⠀⠀⠀⠀⠀⣹⢠⠇⠀⠀⠀⠀⣀⣀⣀⣀⣀⡙⢦⠀]],
[[⡀⠀⠀⠀⠀⠀⠘⢦⡀⠀⢿⠀⣿⠀⠀⠀⠀⢀⣠⣾⣿⡟⣿⣿⣿⣏⠀⠀⠀⠀⣼⡿⠃⢠⣇⡞⠁⢠⣞⠀⠀⢀⡏⣧⢹⡄⠀⠀⠀⠀⢀⣀⣿⣀⣸⠁⠀⠀⠀⠀⠀⠀⠀⠀⣰⠃⢸⠀⠀⠀⣴⠟⠉⠉⠉⠁⠀⠀⣼⠀]],
[[⡇⠀⠉⠓⠲⠤⣄⡀⠱⡄⢸⠀⠸⣆⣀⣤⣶⣿⣿⣿⣿⣧⣿⡿⣿⣿⣷⣤⡀⣰⠏⠀⠀⢸⠉⣠⡶⡟⠈⠛⢶⡚⢀⡇⢸⡇⠀⠀⠀⠀⢈⣿⣿⡿⢿⣿⡟⠛⠁⠀⠀⠀⠀⣸⠃⠀⡇⠀⣠⠞⠁⠀⠀⢀⣀⡀⠀⡼⠃⠀]],
[[⣿⠀⠀⠀⠀⠀⠀⠉⠓⢿⢫⠀⠀⠛⠛⠋⠁⠀⢹⢻⠏⠉⠙⡇⢻⡉⠉⠛⠿⠋⠀⠀⠀⣼⡾⠋⢸⣿⣄⠀⠀⠹⢼⠀⠸⣧⣤⣤⣶⣿⣿⣿⣿⣴⣾⣿⣿⣦⡀⠀⠀⠀⢀⡏⠀⠀⡇⡴⠁⢀⡤⠖⠋⠉⠀⢀⡾⠁⠀⠀]],
[[⣿⠀⠀⠀⠀⠀⠀⠀⠀⢸⠈⣇⠀⠀⠀⠀⠀⠀⡟⣸⠀⠀⠀⠹⣌⢧⡀⠀⠀⠀⠀⠀⢠⡿⠀⠀⣾⣿⣟⣷⠀⢤⣼⠀⠀⠛⠛⠛⠉⠁⡽⢫⠏⠀⣸⠸⡏⠙⢿⣷⣤⣀⣼⠁⠰⣄⠹⣶⠚⠉⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀]],
[[⣿⡇⠀⠀⠀⠀⠀⢰⡄⠘⡆⢹⠀⠀⠀⠀⠀⢸⣇⡿⠀⠀⠀⠀⠹⣆⣻⡄⠀⠀⠀⢀⡞⢁⡤⢀⣿⣿⣿⡌⡇⢤⢸⡀⠀⠀⠀⠀⠀⣸⠃⡾⠀⠀⡟⢰⡇⠀⠀⠈⠉⠉⠁⠀⠀⠹⣦⠇⠀⠀⠀⠀⠀⠀⠀⣼⠀⠀⠀⠀]],
[[⣿⣧⠀⠀⠀⠀⠀⠀⢣⠀⡇⠈⠀⠀⠀⠀⠀⠀⠙⠇⠀⠀⠀⠀⠀⠛⠉⠀⠀⠀⢀⣞⡴⠋⠀⣼⠻⣿⣿⣷⣹⠸⡀⢧⠀⠀⠀⠀⣰⠇⣸⠁⠀⢠⡇⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⡀⠀⠀⡇⠀⠀⠀⠀]],
[[⣿⣿⠀⠀⠀⠀⠀⠀⠘⣇⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠋⠀⠀⠀⣿⡆⠙⣿⣿⣿⠀⢧⠈⣆⠀⠀⠐⠯⢴⠏⠀⠀⣼⣁⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⠀⢳⡀⠀⡇⠀⠀⠀⠀]],
[[⣿⣿⡇⠀⠀⠀⠀⠀⠀⠘⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⠁⠀⠀⠀⠀⣿⣷⠀⠈⢿⣿⡆⠘⡆⠘⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡇⢰⡇⠀⠀⠀⠀]],
}
dashboard.section.buttons.val = {
	dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
	dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
	dashboard.button("s", " " .. " Create packer snapshot", ":lua require('user.lib.utils').create_packer_snapshot()<CR>"),
	dashboard.button("q", " " .. " Quit", ":qa<CR>"),
}

local quotes = {
	"Pain is weakness leaving the body",
	"Life is a banquet, and most poor suckers are starving to death !",
	"Waiting for something to happen?",
	"Maybe you have some bird ideas. Maybe that’s the best you can do.",
	"'I can figure this out.'",
	"10 years ago or today, life is worth living",
}
local function footer()
	math.randomseed(os.time())
	return quotes[math.random(1, #quotes)]
	-- return quotes[#quotes]
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
