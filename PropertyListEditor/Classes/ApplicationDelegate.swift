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
    @IBOutlet private var updater: GitHubUpdater!
    
    func applicationDidFinishLaunching( _ notification: Notification )
    {
        DispatchQueue.main.asyncAfter( deadline: .now() + .seconds( 2 ) )
        {
            self.updater.checkForUpdatesInBackground()
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed( _ sender: NSApplication ) -> Bool
    {
        false
    }
    
    @IBAction func checkForUpdates( _ sender: Any? )
    {
        self.updater.checkForUpdates( sender )
    }
    
    @IBAction func invertAppearance( _ sender: Any? )
    {
        switch NSApp.effectiveAppearance.name
        {
            case .aqua:                                  NSApp.appearance = NSAppearance( named: .darkAqua )
            case .darkAqua:                              NSApp.appearance = NSAppearance( named: .aqua )
            case .accessibilityHighContrastAqua:         NSApp.appearance = NSAppearance( named: .accessibilityHighContrastDarkAqua )
            case .accessibilityHighContrastDarkAqua:     NSApp.appearance = NSAppearance( named: .accessibilityHighContrastAqua )
            case .vibrantLight:                          NSApp.appearance = NSAppearance( named: .vibrantDark )
            case .vibrantDark:                           NSApp.appearance = NSAppearance( named: .vibrantLight )
            case .accessibilityHighContrastVibrantLight: NSApp.appearance = NSAppearance( named: .accessibilityHighContrastVibrantDark )
            case .accessibilityHighContrastVibrantDark:  NSApp.appearance = NSAppearance( named: .accessibilityHighContrastVibrantLight )
            
            default: NSSound.beep()
        }
    }
}
