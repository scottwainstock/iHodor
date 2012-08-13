@protocol MenuBarDelegate <NSObject>
- (void)backButtonPressed;
- (void)showChat:(bool)animated;
- (void)showPose:(bool)animated;
@end

@interface HodorMenuBar : UIView {
    id <MenuBarDelegate> __unsafe_unretained delegate;
}

@property(nonatomic,unsafe_unretained)id delegate;

- (IBAction)backButtonPressed;
- (IBAction)chatButtonPressed;
- (IBAction)poseButtonPressed;
- (IBAction)shareButtonPressed;

@end