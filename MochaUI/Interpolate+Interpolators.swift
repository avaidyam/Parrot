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
