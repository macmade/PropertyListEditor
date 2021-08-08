/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2021 Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Cocoa
import GitHubUpdates

@main class ApplicationDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate
{
    private var aboutWindowController = AboutWindowController()
    private var windowControllers     = [ MainWindowController ]()
    
    @IBOutlet private var updater: GitHubUpdater!
    
    func applicationDidFinishLaunching( _ notification: Notification )
    {
        self.openDocument( nil )
        
        DispatchQueue.main.asyncAfter( deadline: .now() + .seconds( 2 ) )
        {
            self.updater.checkForUpdatesInBackground()
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed( _ sender: NSApplication ) -> Bool
    {
        false
    }
    
    func application( _ sender: NSApplication, openFile filename: String ) -> Bool
    {
        self.open( url: URL( fileURLWithPath: filename ) )
        
        return true
    }
    
    func open( url: URL )
    {}
    
    @IBAction func openDocument( _ sender: Any? )
    {
        let panel                     = NSOpenPanel()
        panel.canChooseFiles          = true
        panel.canChooseDirectories    = false
        panel.canCreateDirectories    = false
        panel.allowsMultipleSelection = true
        panel.allowsOtherFileTypes    = false
        panel.allowedFileTypes        = [ "plist" ]
        
        guard panel.runModal() == .OK, panel.urls.count > 0 else
        {
            return
        }
        
        for url in panel.urls
        {
            do
            {
                self.show( controller: try MainWindowController( url: url ) )
            }
            catch let error
            {
                NSAlert( error: error ).runModal()
            }
        }
    }
    
    @IBAction func newDocument( _ sender: Any? )
    {
        self.show( controller: MainWindowController() )
    }
    
    private func show( controller: MainWindowController )
    {
        controller.window?.delegate = self
        
        controller.window?.layoutIfNeeded()
        controller.window?.makeKeyAndOrderFront( nil )
        self.windowControllers.append( controller )
    }
    
    func windowWillClose( _ notification: Notification )
    {
        guard let window = notification.object as? NSWindow else
        {
            return
        }
        
        self.windowControllers.removeAll
        {
            $0.window == window
        }
    }
    
    @IBAction func showAboutWindow( _ sender: Any? )
    {
        self.aboutWindowController.window?.layoutIfNeeded()
        
        if self.aboutWindowController.window?.isVisible == false
        {
            self.aboutWindowController.window?.center()
        }
        
        self.aboutWindowController.window?.makeKeyAndOrderFront( nil )
    }
    
    @IBAction func checkForUpdates( _ sender: Any? )
    {
        self.updater.checkForUpdates( sender )
    }
}
