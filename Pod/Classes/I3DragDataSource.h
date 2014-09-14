//
//  I3DragDataSource.h
//  BetweenKit
//
//  Created by Stephen Fortune on 14/09/2014.
//  Copyright (c) 2013 IceCube Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol I3Collection;


/**
 
 Delegate protocol that provides the data around the state of which items in a collection
 are draggable.
 
 @see UITableViewDataSource
 @see UICollectionViewDataSource
 
 */
@protocol I3DragDataSource <NSObject>


@optional


/**
 
 Called to update the data source on a drop form a foreign collection.
 
 @name Coordination
 @param from            The point from the foreign draggable that the item is from.
 @param to              The point in this draggable to which the foreign item is being dragged.
 @param fromCollection  The foreign collection.
 @param toCollection    The collection we're providing data for.
 
 */
-(void) dropItemAtPoint:(CGPoint) from fromCollection:(id<I3Collection>) fromCollection toPoint:(CGPoint) to inCollection:(id<I3Collection>) toCollection;


/**
 
 Called to update the data source on rearrange.
 
 @name Coordination
 @param from            The point from which the item is being dragged from.
 @param to              The point to which the item is being dragged to.
 @param collection      The collection we're providing data for.
 
 */
-(void) rearrangeItemAtPoint:(CGPoint) from withItemAtPoint:(CGPoint) to inCollection:(id<I3Collection>) collection;


/**
 
 Called to delete an item from the data source on deletion.
 
 @name Coordination
 @param at              The point to which the item was.
 @param collection      The collection we're providing data for.
 
 */
-(void) deleteItemAtPoint:(CGPoint) at inCollection:(id<I3Collection>) collection;


/**
 
 Returns YES or NO based on whether an item at a given point from a foreign draggable can be
 dropped on this draggable at another given point. Assumed as NO if this is not implemented.
 
 @name Coordination
 @param from            The point from the foreign draggable that the item is from.
 @param to              The point in this draggable to which the foreign item is being dragged.
 @param fromCollection  The foreign collection.
 @param collection      The collection we're providing data for.
 @return BOOL
 
 */
-(BOOL) canItemAtPoint:(CGPoint) from fromCollection:(id<I3Collection>) fromCollection beDroppedToPoint:(CGPoint) to inCollection:(id<I3Collection>) collection;


/**
 
 Returns YES or NO based on whether an item at a given point can be exchanged in the container
 with an item at another point. Assumed as NO if this is not implemented.
 
 @name Coordination
 @param from        The point at which the cell is being dragged from.
 @param to          The point at which the cell is being dragged to.
 @param collection  The collection we're providing data for.
 @return BOOL
 
 */
-(BOOL) canItemFromPoint:(CGPoint) from beRearrangedWithItemAtPoint:(CGPoint) to inCollection:(id<I3Collection>) collection;


/**
 
 Returns YES or NO based on whether an item at a given point can be dragged at all. Assumed
 as NO if this is not implemented.
 
 @name Coordination
 @param at          The point at which the cell is being dragged from.
 @param collection  The collection we're providing data for.
 @return BOOL
 
 */
-(BOOL) canItemBeDraggedAtPoint:(CGPoint) at inCollection:(id<I3Collection>) collection;


/**
 
 Returns YES or NO based on whether an item at a given point can be 'deleted' (be the renderer)
 if it is dropped outside of all valid containers. Assumed as NO if this is not implemented.
 
 @name Coordination
 @param from        The point at which the cell is being dragged from.
 @param to          The point outside of the collection to which the item is being dragged.
 @param collection  The collection we're providing data for.
 @return BOOL
 
 */
-(BOOL) canItemAtPoint:(CGPoint) from beDeletedIfDroppedOutsideOfCollection:(id<I3Collection>) collection atPoint:(CGPoint) to;


/**
 
 Should an item's original view be 'hidden' whilst it is being dragged? If YES, the item
 view will appear to have been lifted off the collection and be dragged about. If NO, a
 'ghost' duplicate will appear to track around with the user's pan gesture.
 
 @name Rendering
 @param at          The point at which the item is.
 @param collection  The collection we're providing data for.
 @return BOOL
 
 */
-(BOOL) hidesItemWhileDraggingAtPoint:(CGPoint) at inCollection:(id<I3Collection>) collection;

@end
