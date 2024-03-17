
//
//  main.swift
//  osqueryCliChecker
//
//  Created by Anubhav Gain on 16/03/24.
//
import Foundation

func checkAndInstallOsquery() {
    // Check if osqueryi and osqueryctl are installed using pkg-config
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["pkg-config", "--modversion", "libosquery"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    
    task.launch()
    task.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    
    if let output = output, output.contains("osqueryi") && output.contains("osqueryctl") {
        print("osqueryi and osqueryctl are installed")
        findAndRunOsqueryCommands()
    } else {
        print("osqueryi and osqueryctl are not installed. Installing...")
        installOsquery()
    }
}

func installOsquery() {
    let version = "5.11.0"
    let installURL = "https://github.com/osquery/osquery/releases/download/\(version)/osquery-\(version).pkg"
    let packagePath = "/tmp/osquery.pkg"

    // Download the package
    let downloadTask = Process()
    downloadTask.launchPath = "/usr/bin/env"
    downloadTask.arguments = ["curl", "-L", installURL, "-o", packagePath]
    downloadTask.launch()
    downloadTask.waitUntilExit()

    // Install the package
    let installTask = Process()
    installTask.launchPath = "/usr/sbin/installer"
    installTask.arguments = ["-pkg", packagePath, "-target", "/"]
    installTask.launch()
    installTask.waitUntilExit()

    // Clean up downloaded package
    let fileManager = FileManager.default
    try? fileManager.removeItem(atPath: packagePath)
}

func postInstallationSteps() {
    print("Running post-installation steps...")
    
    do {
        try executeCommand("sudo", "cp", "/var/osquery/osquery.example.conf", "/var/osquery/osquery.conf")
        try executeCommand("sudo", "cp", "/var/osquery/io.osquery.agent.plist", "/Library/LaunchDaemons/")
        try executeCommand("sudo", "launchctl", "load", "/Library/LaunchDaemons/io.osquery.agent.plist")
    } catch {
        print("Error: \(error)")
    }
    
    print("Post-installation steps completed.")
}

func findAndRunOsqueryCommands() {
    let findTask = Process()
    findTask.launchPath = "/usr/bin/env"
    findTask.arguments = ["find", "/opt/osquery/lib/osquery.app/Contents/MacOS", "/opt/osquery/lib/osquery.app/Contents/Resources", "-name", "osqueryi", "-type", "f", "-perm", "+111", "-print", "-quit"]
    
    let pipe = Pipe()
    findTask.standardOutput = pipe
    
    findTask.launch()
    findTask.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let osqueryiPath = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
        print("Could not find osqueryi executable.")
        return
    }
    
    let osqueryctlPath = osqueryiPath.replacingOccurrences(of: "osqueryi", with: "osqueryctl")
    
    do {
        try executeCommand(osqueryiPath)
        try executeCommand(osqueryctlPath)
    } catch {
        print("Error: \(error)")
    }
}

func executeCommand(_ commandPath: String, _ arguments: String...) throws {
    let task = Process()
    task.launchPath = commandPath
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    task.launch()
    task.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = String(data: data, encoding: .utf8), !output.isEmpty {
        print(output)
    }
    
    if task.terminationStatus != 0 {
        let errorMessage = "Command '\(commandPath)' failed with error code \(task.terminationStatus)"
        throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
}

checkAndInstallOsquery()
