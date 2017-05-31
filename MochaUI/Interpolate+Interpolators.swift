import Foundation

public struct LinearInterpolator: Interpolator {
    public init() {}
    
    public func apply(_ progress: CGFloat) -> CGFloat {
        return progress
    }
}

public struct EaseInInterpolator: Interpolator {
    public init() {}
    
    public func apply(_ progress: CGFloat) -> CGFloat {
        return pow(progress, 3)
    }
}

public struct EaseOutInterpolator: Interpolator {
    public init() {}
    
    public func apply(_ progress: CGFloat) -> CGFloat {
        return pow(progress - 1, 3) + 1.0
    }
}

public struct EaseInOutInterpolator: Interpolator {
    public init() {}
    
    public func apply(_ progress: CGFloat) -> CGFloat {
        if progress < 0.5 {
            return 4.0*pow(progress, 3)
        } else {
            let adjustment = (2*progress - 2)
            return 0.5 * pow(adjustment, 3) + 1.0
        }
    }
}

// TODO: Implement these interpolators.
// Key: CGFloat: time, begin, change, duration
/*
CGFloat BINAnimationTimingFunctionBackOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158;
    return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
}

CGFloat BINAnimationTimingFunctionBackIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158;
    return c*(t/=d)*t*((s+1)*t - s) + b;
}

CGFloat BINAnimationTimingFunctionBackInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158;
    if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
    return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
}

CGFloat BINAnimationTimingFunctionBounceOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
    } else {
        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    }
}

CGFloat BINAnimationTimingFunctionBounceIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c - BINAnimationTimingFunctionBounceOut(d-t, 0, c, d) + b;
}

CGFloat BINAnimationTimingFunctionBounceInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (t < d/2) return BINAnimationTimingFunctionBounceIn(t*2, 0, c, d) * .5 + b;
    else return BINAnimationTimingFunctionBounceOut(t*2-d, 0, c, d) * .5 + c*.5 + b;
}

CGFloat BINAnimationTimingFunctionCircOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c * sqrt(1 - (t=t/d-1)*t) + b;
}

CGFloat BINAnimationTimingFunctionCircIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c * (sqrt(1 - (t/=d)*t) - 1) + b;
}

CGFloat BINAnimationTimingFunctionCircInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
    return c/2 * (sqrt(1 - (t-=2)*t) + 1) + b;
}

CGFloat BINAnimationTimingFunctionCubicOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*((t=t/d-1)*t*t + 1) + b;
}

CGFloat BINAnimationTimingFunctionCubicIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t*t + b;
}

CGFloat BINAnimationTimingFunctionCubicInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t*t + b;
    return c/2*((t-=2)*t*t + 2) + b;
}

CGFloat BINAnimationTimingFunctionElasticOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat p = d*.3;
    CGFloat s, a = 0;
    if (t==0) return b;  if ((t/=d)==1) return b+c;
    if (!a || a < ABS(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return (a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b);
}

CGFloat BINAnimationTimingFunctionElasticIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat p = d*.3;
    CGFloat s, a = 0;
    if (t==0) return b;  if ((t/=d)==1) return b+c;
    if (!a || a < ABS(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return -(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
}

CGFloat BINAnimationTimingFunctionElasticInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat p = d*(.3*1.5);
    CGFloat s, a = 0;
    if (t==0) return b;  if ((t/=d/2)==2) return b+c;
    if (!a || a < ABS(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    if (t < 1) return -.5*(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
    return a*pow(2,-10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
}

CGFloat BINAnimationTimingFunctionExpoOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
}

CGFloat BINAnimationTimingFunctionExpoIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
}

CGFloat BINAnimationTimingFunctionExpoInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (t==0) return b;
    if (t==d) return b+c;
    if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
    return c/2 * (-pow(2, -10 * --t) + 2) + b;
}

CGFloat BINAnimationTimingFunctionQuadOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c *(t/=d)*(t-2) + b;
}

CGFloat BINAnimationTimingFunctionQuadIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t + b;
}

CGFloat BINAnimationTimingFunctionQuadInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t + b;
    return -c/2 * ((--t)*(t-2) - 1) + b;
}

CGFloat BINAnimationTimingFunctionQuartOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c * ((t=t/d-1)*t*t*t - 1) + b;
}

CGFloat BINAnimationTimingFunctionQuartIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t*t*t + b;
}

CGFloat BINAnimationTimingFunctionQuartInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
    return -c/2 * ((t-=2)*t*t*t - 2) + b;
}

CGFloat BINAnimationTimingFunctionQuintIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t*t*t*t + b;
}

CGFloat BINAnimationTimingFunctionQuintOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*((t=t/d-1)*t*t*t*t + 1) + b;
}

CGFloat BINAnimationTimingFunctionQuintInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
    return c/2*((t-=2)*t*t*t*t + 2) + b;
}

CGFloat BINAnimationTimingFunctionSineOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c * sin(t/d * (M_PI/2)) + b;
}

CGFloat BINAnimationTimingFunctionSineIn(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c * cos(t/d * (M_PI/2)) + c + b;
}

CGFloat BINAnimationTimingFunctionSineInOut(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c/2 * (cos(M_PI*t/d) - 1) + b;
}
*/

public struct CustomInterpolator: Interpolator {
    public var interpolator: (CGFloat) -> CGFloat
    public init(interpolator: @escaping (CGFloat) -> CGFloat) {
        self.interpolator = interpolator
    }
    
    public func apply(_ progress: CGFloat) -> CGFloat {
        return self.interpolator(progress)
    }
}

public struct SpringInterpolator: Interpolator {
    
    public var damping: CGFloat
    public var velocity: CGFloat
    public var mass: CGFloat
    public var stiffness: CGFloat
    
    public init(damping: CGFloat = 10.0, velocity: CGFloat = 0.0, mass: CGFloat = 1.0, stiffness: CGFloat = 100.0) {
        self.damping = damping
        self.velocity = velocity
        self.mass = mass
        self.stiffness = stiffness
    }
    
    public func apply(_ progress: CGFloat) -> CGFloat {
        if damping <= 0.0 || stiffness <= 0.0 || mass <= 0.0 {
            fatalError("Incorrect animation values")
        }
        
        let beta = damping / (2 * mass)
        let omega0 = sqrt(stiffness / mass)
        let omega1 = sqrt((omega0 * omega0) - (beta * beta))
        let omega2 = sqrt((beta * beta) - (omega0 * omega0))
        
        let x0: CGFloat = -1
        let oscillation: (CGFloat) -> CGFloat
        if beta < omega0 { // Underdamped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
                
                let part2: CGFloat = x0 * cos(omega1 * t)
                let part3: CGFloat = ((beta * x0 + self.velocity) / omega1) * sin(omega1 * t)
                return -x0 + envelope * (part2 + part3)
            }
        } else if beta == omega0 { // Critically damped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
                return -x0 + envelope * (x0 + (beta * x0 + self.velocity) * t)
            }
        } else { // Overdamped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
                let part2: CGFloat = x0 * cosh(omega2 * t)
                let part3: CGFloat = ((beta * x0 + self.velocity) / omega2) * sinh(omega2 * t)
                return -x0 + envelope * (part2 + part3)
            }
        }
        return oscillation(progress)
    }
}
