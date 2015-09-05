//
//  AccountDB+CoreDataProperties.swift
//  SinaWeibo
//
//  Created by baby on 15/9/5.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AccountDB {

    @NSManaged var access_token: String?
    @NSManaged var expires_in: NSNumber?
    @NSManaged var uid: String?
    @NSManaged var date: NSDate?

}
