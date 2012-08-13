#import "HodorMenuBar.h"

@interface HodorViewController : UIViewController {
    IBOutlet HodorMenuBar *menuBar;
    id <MenuBarDelegate> __unsafe_unretained menuBarDelegate;
}

@property(nonatomic)HodorMenuBar *menuBar;
@property(nonatomic,unsafe_unretained)id menuBarDelegate;

- (void)backButtonPressed;
- (void)showChat:(bool)animated;
- (void)showPose:(bool)animated;
- (void)showAbout:(bool)animated;
- (void)showHelp:(bool)animated;

@end