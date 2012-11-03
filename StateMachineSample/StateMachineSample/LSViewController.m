#import "LSViewController.h"
#import "LSSubscripton.h"

@interface LSViewController ()
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UIButton *activateButton;
@property (strong, nonatomic) IBOutlet UIButton *suspendButton;
@property (strong, nonatomic) IBOutlet UIButton *unsuspendButton;
@property (strong, nonatomic) IBOutlet UIButton *terminateButton;

@property (strong, nonatomic) LSSubscripton *subscription;

- (void) updateUI;
@end

@implementation LSViewController
@synthesize stateLabel;
@synthesize activateButton;
@synthesize suspendButton;
@synthesize unsuspendButton;
@synthesize terminateButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.subscription = [[LSSubscripton alloc] init];
    [self.subscription addObserver:self forKeyPath:@"state" options:0 context:NULL];
    [self updateUI];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setStateLabel:nil];
    [self setActivateButton:nil];
    [self setSuspendButton:nil];
    [self setUnsuspendButton:nil];
    [self setTerminateButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)activateButtonTapped:(id)sender {
    [self.subscription activate];
}
- (IBAction)suspendButtonTapped:(id)sender {
    [self.subscription suspend];
}
- (IBAction)unsuspendButtonTapped:(id)sender {
    [self.subscription unsuspend];
}
- (IBAction)terminateButtonTapped:(id)sender {
    [self.subscription terminate];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == NULL) {
        [self updateUI];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void) updateUI {
    self.stateLabel.text = self.subscription.state;
    self.activateButton.enabled = [self.subscription canActivate];
    self.suspendButton.enabled = [self.subscription canSuspend];
    self.unsuspendButton.enabled = [self.subscription canUnsuspend];
    self.terminateButton.enabled = [self.subscription canTerminate];

}
@end
