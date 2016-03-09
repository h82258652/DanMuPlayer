//
//  ArticleEntity+CoreDataProperties.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ArticleEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *up;
@property (nullable, nonatomic, retain) NSNumber *articleId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *views;

@end

NS_ASSUME_NONNULL_END
