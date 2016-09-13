//
//  PlayerTableViewCell.m
//  ZHIBO
//
//  Created by qianfeng on 16/9/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "PlayerTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kcreenHeight [UIScreen mainScreen].bounds.size.height
#define Ratio 618/480
@interface PlayerTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end


@implementation PlayerTableViewCell


- (void)setModel:(PlayerModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    if ([model.city isEqualToString:@""]) {
        self.addressLabel.text = @"难道在火星?";
    }else{
        self.addressLabel.text = model.city;
    }
    NSString *iconUrlString = [NSString stringWithFormat:@"http://img.meelive.cn/%@",model.portrait];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrlString]];
    self.iconImageView.layer.cornerRadius = 20;
    self.iconImageView.clipsToBounds = true;

    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",model.portrait]]];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kScreenWidth * Ratio - 40 - 5 - 20 + 1);
    }];
    
    self.peopleNumLabel.text = [NSString stringWithFormat:@"%d",model.online_users];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
