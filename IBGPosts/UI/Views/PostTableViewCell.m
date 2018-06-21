//
//  PostTableViewCell.m
//  IBGPosts
//
//  Created by Fady on 6/15/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addTitleLabelViewWithAutoLayoutConstraints];
        [self addBodyLabelViewWithAutoLayoutConstraints];
    }
    
    return self;
}

- (void)addTitleLabelViewWithAutoLayoutConstraints {
    [self.contentView addSubview:self.titleLabel];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
                                              [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                                              [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
                                              ]];
}

- (void)addBodyLabelViewWithAutoLayoutConstraints {
    [self.contentView addSubview:self.bodyLabel];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.bodyLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor],
                                              [self.bodyLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
                                              [self.bodyLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8]
                                              ]];
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _titleLabel;
}

- (UILabel *)bodyLabel {
    if (!_bodyLabel) {
        _bodyLabel = [[UILabel alloc] init];
        [_bodyLabel setFont:[UIFont systemFontOfSize:12]];
        [_bodyLabel setTextColor:[UIColor lightGrayColor]];
        _bodyLabel.numberOfLines = 0;
        [_bodyLabel sizeToFit];
        _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _bodyLabel;
}

@end
