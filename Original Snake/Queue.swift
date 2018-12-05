//
//  Queue.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 04/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import Foundation

public struct Queue<T>: Sequence {
    public typealias Element = T
    
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
    
    public var end: T? {
        if isEmpty {
            return nil
        } else {
            return array[array.count-1]
        }
    }
    
    public func makeIterator() -> Queue<T>.Iterator {
        return Iterator(queue: self, iterationIndex: 0)
    }
    
    public struct Iterator: IteratorProtocol {
        public typealias Iterator = T
        
        let queue: Queue
        var iterationIndex: Int = 0
        
        public mutating func next() -> T? {
            guard iterationIndex < queue.count else { return nil }
            let elem = queue.array[queue.head + iterationIndex]
            iterationIndex += 1
            return elem
        }
        
    }
}


