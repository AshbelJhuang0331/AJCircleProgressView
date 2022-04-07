//
//  AJCircleProgressView.m
//  ObjCPlayground
//
//  Created by ChuanJie Jhuang on 2020/5/20.
//  Copyright © 2020 ChuanJie Jhuang. All rights reserved.
//

#import "AJCircleProgressView.h"

@interface AJCircleProgressView()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *circularTrackShapeLayer;
@property (nonatomic, strong) CAShapeLayer *circularStrokeShapeLayer;
@property (nonatomic, strong) CAShapeLayer *pulseLayer;
@property (nonatomic, assign) IBInspectable CGFloat animatedEndProgress;

@property (nonatomic, copy) void (^animatedToStrokeEndProgressCompletion)(void);

@end

@implementation AJCircleProgressView

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)didMoveToWindow {
    if (self.window) {
        // Added to a window, similar to -viewDidLoad.
        // Subscribe to notifications here.
        
//        self.pulseLayer = [[CAShapeLayer alloc] init];
//        self.pulseLayer.path = circularPath.CGPath;
//        self.pulseLayer.strokeColor = [[UIColor clearColor] CGColor];
//        self.pulseLayer.fillColor = [[UIColor systemYellowColor] CGColor];
//        self.pulseLayer.lineWidth = 0;
//        self.pulseLayer.lineCap = kCALineCapRound;
//        self.pulseLayer.position = viewCenter;
//        [self.layer addSublayer:self.pulseLayer];
        
        if (self.circularTrackShapeLayer == nil) {
            self.circularTrackShapeLayer = [self createCircularShapeLayer];
            self.circularTrackShapeLayer.fillColor = [[UIColor clearColor] CGColor];
            self.circularTrackShapeLayer.strokeColor = [self.trackColor CGColor];
            [self.layer addSublayer:self.circularTrackShapeLayer];
        }
        
        if (self.circularStrokeShapeLayer == nil) {
            self.circularStrokeShapeLayer = [self createCircularShapeLayer];
            self.circularStrokeShapeLayer.fillColor = [[UIColor clearColor] CGColor];
            self.circularStrokeShapeLayer.strokeColor = [self.strokeColor CGColor];
            self.circularStrokeShapeLayer.strokeEnd = self.progress;
            [self.layer addSublayer:self.circularStrokeShapeLayer];
        }
        
        
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAction:)]];
        
//        [self animatePulsing];
        
//        [self addNotificationObserver];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        // Will be removed from window, similar to -viewDidUnload.
        // Unsubscribe from any notifications here.
        
    }
}

#pragma mark - Override

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        [self animateCircleToEndProgress:progress andDuration:0 withCompletion:^{}];
    }
}

#pragma mark - IBAction

//- (void)tappedAction:(UITapGestureRecognizer *)sender {
//    [self animateCircle];
//}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CABasicAnimation *strokeAnimation = (CABasicAnimation *)anim;
    if ([strokeAnimation.keyPath isEqualToString:@"strokeEnd"]) {
        self.circularStrokeShapeLayer.strokeEnd = self.animatedEndProgress;
        self.progress = self.animatedEndProgress;
        if (self.animatedToStrokeEndProgressCompletion) {
            self.animatedToStrokeEndProgressCompletion();
        }
    }
}

#pragma mark - Public Method

- (void)animateCircleToEndProgress:(CGFloat)endProgress andDuration:(CFTimeInterval)duration withCompletion:(void(^)(void))completion {
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.toValue = (id)@(endProgress);
    strokeAnimation.duration = duration;
    strokeAnimation.fillMode = kCAFillModeForwards;
    strokeAnimation.removedOnCompletion = NO;
    strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    strokeAnimation.delegate = self;
    
    self.animatedEndProgress = endProgress;
    
    [self.circularStrokeShapeLayer addAnimation:strokeAnimation forKey:@"strokeEnd"];
    if (completion) {
        self.animatedToStrokeEndProgressCompletion = completion;
    }
}

#pragma mark - Private Method
- (CAShapeLayer *)createCircularShapeLayer {
    CGPoint viewCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    UIBezierPath *circularPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:MIN(self.bounds.size.width / 2, self.bounds.size.height / 2) startAngle:-1 * M_PI_2 endAngle:3 * M_PI / 2 clockwise:YES];
    
    CAShapeLayer *circularShapeLayer = [[CAShapeLayer alloc] init];
    circularShapeLayer.path = circularPath.CGPath;
    circularShapeLayer.lineWidth = 10;
    circularShapeLayer.lineCap = kCALineCapRound;
    circularShapeLayer.position = viewCenter;
    return circularShapeLayer;
}

- (void)baseInit {
    self.progress = 0.0;
    self.animatedEndProgress = 1.0;
    self.trackColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.strokeColor = [UIColor colorWithWhite:1.0 alpha:1.0];
}

- (void)animatePulsing {
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.toValue = (id)@1.5;
    pulseAnimation.duration = 0.8;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = INFINITY;
    
    [self.pulseLayer addAnimation:pulseAnimation forKey:@"pulsing"];
}

- (void)addNotificationObserver {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAnimatingPulsing) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animatePulsing) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
