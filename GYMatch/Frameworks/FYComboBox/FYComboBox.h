#import <UIKit/UIKit.h>

@class FYComboBox;

@protocol FYComboBoxDelegate <NSObject>

- (NSInteger)comboBoxNumberOfRows:(FYComboBox *)comboBox;
- (NSString *)comboBox:(FYComboBox *)comboBox titleForRow:(NSInteger)row;

@optional
- (void)comboBox:(FYComboBox *)comboBox willOpenAnimated:(BOOL)animated;
- (void)comboBox:(FYComboBox *)comboBox didOpenAnimated:(BOOL)animated;
- (void)comboBox:(FYComboBox *)comboBox willCloseAnimated:(BOOL)animated;
- (void)comboBox:(FYComboBox *)comboBox didCloseAnimated:(BOOL)animated;
- (void)comboBox:(FYComboBox *)comboBox didSelectRow:(NSInteger)row;
- (CGFloat)comboBox:(FYComboBox *)comboBox heightForRow:(NSInteger)row;

@end

typedef NS_ENUM(NSInteger, FYComboBoxState) {
    FYComboBoxStateOpened,
    FYComboBoxStateClosed,
};

IB_DESIGNABLE
@interface FYComboBox : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBInspectable NSInteger maxRows;
@property (nonatomic, assign) IBInspectable CGFloat cellHeight;
@property (nonatomic, strong) IBInspectable UIColor *cellBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *cellTextColor;
@property (nonatomic, strong) IBInspectable UIFont *cellTextFont;
@property (nonatomic, strong) IBInspectable UIColor *cellLineColor;
@property (nonatomic, strong) IBInspectable UIColor *comboBackgroundColor;
@property (nonatomic, assign) IBInspectable CGFloat minimumWidth;
@property (nonatomic, assign) IBInspectable BOOL showsScrollIndicator;
@property (nonatomic, assign) IBInspectable double animationShowDuration;
@property (nonatomic, assign) IBInspectable double animationHideDuration;

@property (nonatomic, weak) IBOutlet UIView *comboToView;
@property (nonatomic, weak) IBOutlet id<FYComboBoxDelegate> delegate;

@property (nonatomic, assign, readonly) FYComboBoxState state;

- (void)openAnimated:(BOOL)animated;
- (void)closeAnimated:(BOOL)animated;

- (void)setState:(FYComboBoxState)state animated:(BOOL)animated;

@end
