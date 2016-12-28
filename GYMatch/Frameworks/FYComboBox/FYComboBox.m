#import "FYComboBox.h"

@interface FYComboBox ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation FYComboBox

static NSString *cellIdentifier = @"FYComboBoxCellIdentifier";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.button.backgroundColor = [UIColor clearColor];
    [self.button setTitle:@"" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(comboTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.button];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.tableView];
    
    [self setDefaultValues];
}

- (void)setDefaultValues
{
    self.maxRows = 3;
    self.cellHeight = 50.f;
    self.cellBackgroundColor = [UIColor whiteColor];
    self.cellTextColor = [UIColor blackColor];
    self.cellTextFont = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier].textLabel.font;
    self.cellLineColor = [UIColor clearColor];
    self.comboBackgroundColor = [UIColor clearColor];
    self.minimumWidth = CGFLOAT_MAX;
    self.showsScrollIndicator = YES;
    self.animationShowDuration = .25;
    self.animationHideDuration = .25;
}

- (CGFloat)heightWithMaxRows:(NSInteger)maxRows
{
    NSInteger rows = [self.delegate comboBoxNumberOfRows:self];
    
    CGFloat total = 0.0f;
    
    for (int i = 0; i < maxRows && i < rows; i++) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:heightForRow:)]) {
            total += [self.delegate comboBox:self heightForRow:i];
        } else {
            total += self.cellHeight;
        }
    }
    
    return total;
}

- (void)openAnimated:(BOOL)animated
{
    if (self.state == FYComboBoxStateClosed) {
        [self.tableView reloadData];
        
        if ([self.delegate comboBoxNumberOfRows:self] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:willOpenAnimated:)]) {
        [self.delegate comboBox:self willOpenAnimated:animated];
    }
    
    CGRect buttonFrame = self.button.frame;
    CGRect tableFrame = CGRectMake(0, CGRectGetHeight(buttonFrame), CGRectGetWidth(self.frame), CGRectGetHeight(self.tableView.frame));
    
    UIView *toView = self.comboToView != nil ? self.comboToView : self;
    
    if (self.tableView.superview != toView) {
        [toView addSubview:self.tableView];
    }
    
    tableFrame = [self convertRect:tableFrame toView:toView];
    
    self.tableView.frame = tableFrame;
    
    CGFloat height = [self heightWithMaxRows:self.maxRows];
    tableFrame.size.height = height;
    tableFrame.size.width = self.minimumWidth != CGFLOAT_MAX ? MAX(self.minimumWidth, CGRectGetWidth(buttonFrame)) : CGRectGetWidth(buttonFrame);
    
    CGRect newFrame = self.frame;
    
    if (toView == self) {
        newFrame.size.height = CGRectGetHeight(buttonFrame) + height;
    }
    
    void(^openBlock)() = ^{
        self.frame = newFrame;
        self.tableView.frame = tableFrame;
    };
    
    void(^completion)() = ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:didOpenAnimated:)]) {
            [self.delegate comboBox:self didOpenAnimated:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationShowDuration animations:openBlock completion:^(BOOL finished) {
            completion();
        }];
    } else {
        openBlock();
        completion();
    }
}

- (void)closeAnimated:(BOOL)animated
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:willCloseAnimated:)]) {
        [self.delegate comboBox:self willCloseAnimated:animated];
    }
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = 0;
    
    CGRect newFrame = self.frame;
    newFrame.size.height = CGRectGetHeight(self.button.frame);
    
    void(^closeBlock)() = ^{
        self.frame = newFrame;
        self.tableView.frame = tableFrame;
    };
    
    void(^completion)() = ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:didCloseAnimated:)]) {
            [self.delegate comboBox:self didCloseAnimated:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationHideDuration animations:closeBlock completion:^(BOOL finished) {
            completion();
        }];
    } else {
        closeBlock();
        completion();
    }
}

#pragma mark - Interface Builder

- (void)prepareForInterfaceBuilder
{
}

#pragma mark - Events

- (void)comboTouch:(id)sender
{
    switch (self.state) {
        case FYComboBoxStateOpened: {
            [self closeAnimated:YES];
        }
            break;
            
        case FYComboBoxStateClosed: {
            [self openAnimated:YES];
        }
            break;
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = self.comboBackgroundColor;
    tableView.showsVerticalScrollIndicator = self.showsScrollIndicator;
    tableView.rowHeight = self.cellHeight;
    
    return [self.delegate comboBoxNumberOfRows:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger lineTag = 100;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        
        UIView *lineView = [UIView new];
        lineView.tag = lineTag;
        lineView.backgroundColor = [UIColor clearColor];
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cell.contentView addSubview:lineView];
        
        NSDictionary *views = @{@"line": lineView};
        
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(1)]-0-|" options:0 metrics:nil views:views]];
        
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line]-0-|" options:0 metrics:nil views:views]];
        
        [cell.contentView setNeedsUpdateConstraints];
    }
    
    UIView *lineView = [cell.contentView viewWithTag:100];
    
    lineView.backgroundColor = self.cellLineColor;
    
    cell.contentView.backgroundColor = self.cellBackgroundColor;
    cell.textLabel.textColor = self.cellTextColor;
    cell.textLabel.font = self.cellTextFont;
    
    cell.textLabel.text = [self.delegate comboBox:self titleForRow:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:didSelectRow:)]) {
        [self.delegate comboBox:self didSelectRow:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.cellHeight;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:heightForRow:)]) {
        height = [self.delegate comboBox:self heightForRow:indexPath.row];
    }
    
    return height;
}

#pragma mark - Setters

- (void)setState:(FYComboBoxState)state animated:(BOOL)animated
{
    switch (state) {
        case FYComboBoxStateOpened: {
            [self openAnimated:animated];
        }
            break;
            
        case FYComboBoxStateClosed: {
            [self closeAnimated:animated];
        }
            break;
    }
}

#pragma mark - Getters

- (FYComboBoxState)state
{
    return CGRectGetHeight(self.tableView.frame) == 0.f ? FYComboBoxStateClosed : FYComboBoxStateOpened;
}

@end
