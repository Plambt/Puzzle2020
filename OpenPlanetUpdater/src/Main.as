void Main () {
	
	auto@ ScriptVersion = Net::HttpGet("https://raw.githubusercontent.com/Plambt/Puzzle2020/main/ScriptVersion.txt");
	while (!ScriptVersion.Finished()) {
       	yield();
   	};
	string CurrentVersionJSON = IO::FromDataFolder("Puzzle2020_Version.json");
	string VersionData = Json::Write(Json::FromFile(CurrentVersionJSON)).Replace("\"", "");

	if (VersionData != ScriptVersion.String()) {

		//Register source files

		auto@ MapType = Net::HttpGet("https://raw.githubusercontent.com/Plambt/Puzzle2020/main/Scripts/MapTypes/Trackmania/Puzzle.Script.txt");
		auto@ PuzzleSolo = Net::HttpGet("https://raw.githubusercontent.com/Plambt/Puzzle2020/main/Scripts/Modes/Trackmania/Puzzle/PuzzleSolo.Script.txt");
		while (!MapType.Finished() || !PuzzleSolo.Finished()){
			yield();
		}

		//Let the user know what the script is doing

		print("Updating Puzzle scripts to " + ScriptVersion.String());
		string userFolderPath = IO::FromUserGameFolder("").Replace("\\", "/");

		//Create Script Folders in case they're missing.

		IO::CreateFolder(userFolderPath + "/Scripts");
		IO::CreateFolder(userFolderPath + "/Scripts/Modes");
		IO::CreateFolder(userFolderPath + "/Scripts/Modes/Trackmania");
		IO::CreateFolder(userFolderPath + "/Scripts/Modes/Trackmania/Puzzle");
		IO::CreateFolder(userFolderPath + "/Scripts/MapTypes");
		IO::CreateFolder(userFolderPath + "/Scripts/MapTypes/Trackmania");

		//Save Maptype
		IO::File MapTypeFile(userFolderPath + "/Scripts/MapTypes/Trackmania/Puzzle.Script.txt", IO::FileMode::Write);
		MapTypeFile.Write(MapType.String());
		print("MapType Updated");

		//Save Solo Mode
		IO::File PuzzleSoloFile(userFolderPath + "/Scripts/Modes/Trackmania/Puzzle/PuzzleSolo.Script.txt", IO::FileMode::Write);
		PuzzleSoloFile.Write(PuzzleSolo.String());
		print("Solo mode Updated");

		Json::Value NewVersionData = Json::Object();
		Json::ToFile(CurrentVersionJSON, ScriptVersion.String());

		UI::ShowNotification("\\$bf9" + Icons::PuzzlePiece + "Puzzle mode updated to " + ScriptVersion.String() + " sucessfully!", "Don't forget to open Puzzle maps in the editor to play them!", 10000);
	}
	else {
		print("Puzzle 2020 is up to date!");
	}
}