//
//  DragDropView.swift
//  SimulatorController
//
//  Created by David Lawson on 5/03/2016.
//

import Cocoa

@objc protocol DragDropViewDelegate: class
{
    func dragDropViewGotURL(appURL: NSURL)
}

class DragDropView: NSView
{
    @IBOutlet weak var nameView: NSTextField!
    @IBOutlet weak var delegate: DragDropViewDelegate!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.registerForDraggedTypes([
            NSURLPboardType
        ])
        
        let layer = CALayer()
        layer.backgroundColor = NSColor(white: 0.9, alpha: 1).CGColor
        self.wantsLayer = true
        self.layer = layer
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation
    {
        let pboard = sender.draggingPasteboard()
        
        if pboard.types!.contains(NSURLPboardType)
        {
            let file = NSURL(fromPasteboard: pboard)!
            return file.path!.hasSuffix(".app") ? .Link : .None
        }
        
        return .None
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool
    {
        let pboard = sender.draggingPasteboard()
        let file = NSURL(fromPasteboard: pboard)!
        self.nameView.stringValue = file.pathComponents!.last!
        
        self.delegate.dragDropViewGotURL(file)
        
        return true
    }
}
