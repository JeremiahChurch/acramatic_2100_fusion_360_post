/**
  Copyright (C) 2012-2024 by Autodesk, Inc.
  All rights reserved.

  Autodesk intermediate post processor configuration.

  $Revision: 44110 51bffa3d7e58870b3886dc8a144e7bb21c0e7878 $
  $Date: 2024-02-05 07:58:54 $

  FORKID {D38E0AF6-F1A7-4C6D-A0FA-C99BB29E65AE}
*/

description = "Export CNC file to Visual Studio Code";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2024 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 41666;

longDescription = "Postprocessor to generate CNC files for use with the Autodesk Fusion Post Processor extension for Visual Studio Code.";

capabilities = CAPABILITY_INTERMEDIATE;

// user-defined properties
properties = {
  interrogate: {
    title      : "Show installation folder",
    description: "Display the VS-code CNC folder in the output file.",
    type       : "boolean",
    value      : false,
    scope      : "post",
    visible    : "false"
  },
  cncFolder: {
    title      : "CNC output folder",
    description: "Select subfolder for the output CNC file.",
    type       : "string",
    value      : "Custom",
    scope      : "post"
  }
};

function onSection() {
  skipRemainingSection();
}

function onClose() {
  var cncPath = getIntermediatePath();
  var fileName = FileSystem.getFilename(cncPath);
  var destPath = FileSystem.getFolderPath(getOutputPath());

  if (getPlatform() == "WIN32") {
    if (!FileSystem.isFolder(FileSystem.getTemporaryFolder())) {
      FileSystem.makeFolder(FileSystem.getTemporaryFolder());
    }
    var path = FileSystem.getTemporaryFile("post");

    var registryPaths = [
      "HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{F8A2A208-72B3-4D61-95FC-8A65D340689B}_is1",
      "HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{C26E74D1-022E-4238-8B9D-1E7564A36CC9}_is1",
      "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{EA457B21-F73E-494C-ACAB-524FDE069978}_is1",
      "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{1287CAD5-7C8D-410D-88B9-0D1EE4A83FF2}_is1",
      "HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{771FD6B0-FA20-440A-A002-3B3BAC16DC50}_is1",
      "HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{D628A17A-9713-46BF-8D57-E671B46A741E}_is1"
    ];

    var exePath;
    for (var i = 0; i < registryPaths.length; ++i) {
      if (hasRegistryValue(registryPaths[i], "InstallLocation")) {
        exePath = getRegistryString(registryPaths[i], "InstallLocation");
        if (FileSystem.isFile(exePath + "\\code.exe")) {
          break; // found
        }
      }
    }

    if (exePath) {
      exePath = FileSystem.getCombinedPath(exePath, "\\bin\\code.cmd");
    } else {
      error(localize("Visual Studio Code not found."));
      return;
    }

    var a = "code --list-extensions --show-versions";
    execute(exePath, a + ">" + path, false, "");

    var result = {};
    try {
      var file = new TextFile(path, false, "utf-8");
      while (true) {
        var line = file.readln();
        var index = line.indexOf("@");
        if (index >= 0) {
          var name = line.substr(0, index);
          var value = line.substr(index + 1);
          result[name] = value;
        }
      }
    } catch (e) {
      // fail
    }
    file.close();

    FileSystem.remove(path);

    var foundExtension = false;
    var extension;
    for (var name in result) {
      var value = result[name];
      switch (name.toLowerCase()) {
      case "autodesk.hsm-post-processor":
        extension = name + "-" + value;
        foundExtension = true;
        break;
      }
    }
    if (!foundExtension) {
      error(localize("Autodesk Fusion Post Processor extension not found."));
      return;
    }

    var userProfile = getEnvironmentVariable("USERPROFILE");
    var extensionFolder = FileSystem.getCombinedPath(userProfile, "\\.vscode\\extensions\\" + extension);

    if (FileSystem.isFile(cncPath)) {
      if (!FileSystem.isFolder(extensionFolder)) {
        error(localize("Autodesk Fusion Post Processor extension not found."));
        return;
      }
      if (customFolder == "") {
        error(localize("You cannot specify a blank folder"));
        return;
      }
      var cncFolder = FileSystem.getCombinedPath(extensionFolder, "\\res\\CNC files\\");
      if (getProperty("interrogate")) {
        writeln(cncFolder);
        return;
      }
      var customFolder = FileSystem.getCombinedPath(cncFolder, getProperty("cncFolder"));
      if (!FileSystem.isFolder(customFolder)) {
        FileSystem.makeFolder(customFolder);
      }
      FileSystem.copyFile(cncPath, FileSystem.getCombinedPath(customFolder, fileName));
    }
    writeln("Success, your CNC file " + "\"" + fileName + "\"" + " is now located in " + "\"" + customFolder + "\"" + " and you can select it in VS Code.");
  } else { // non windows
    FileSystem.copyFile(cncPath, FileSystem.getCombinedPath(destPath, fileName));
    writeln("Success, your CNC file " + "\"" + fileName + "\"" + " is now located in " + "\"" + destPath + "\"" + ".");
    writeln("You need to manually import the CNC file in VS Code by a right click into the CNC Selector panel and select 'Import CNC file...'.");
  }
}

//Dummy function for additive toopath
function onLinearExtrude() {
}

function onCircularExtrude() {
}
