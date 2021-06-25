//
//  main.swift
//  SwiftPropertyWrapper
//
//  Created by 綦 on 2021/6/24.
//

import Foundation

@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { number }
        set { number = min(newValue, 12) }
    }
}

enum Version: CaseIterable {
    case firstVersion, secondVersion, thirdVersion
}

for version in Version.allCases {
    switch version {
    case .firstVersion:
        struct SmallRectangle {
            @TwelveOrLess var height: Int
            @TwelveOrLess var width: Int
        }

        var rectangle = SmallRectangle()
        print(rectangle.height)

        rectangle.height = 10
        print(rectangle.height)

        rectangle.height = 24
        print(rectangle.height)
    case .secondVersion:
        struct SmallRectangle {
            private var _height = TwelveOrLess()
            private var _width = TwelveOrLess()
            var height: Int {
                get { _height.wrappedValue }
                set { _height.wrappedValue = newValue }
            }
            var width: Int {
                get { _width.wrappedValue }
                set { _width.wrappedValue = newValue }
            }
        }


        @propertyWrapper
        struct SmallNumber {
            private var maximum: Int
            private var number: Int
            var wrappedValue: Int {
                get { number }
                set { number = min(newValue, maximum) }
            }
            
            init() {
                maximum = 12
                number = 0
            }
            init(wrappedValue: Int) {
                maximum = 12
                number = min(wrappedValue, maximum)
            }
            init(wrappedValue: Int, maximum: Int) {
                self.maximum = maximum
                number = min(wrappedValue, maximum)
            }
        }


        struct ZeroRectangle {
            @SmallNumber var height: Int
            @SmallNumber var width: Int
        }

        let zeroRectangle = ZeroRectangle()
        print(zeroRectangle.height, zeroRectangle.width)


        struct UnitRectangle {
            @SmallNumber var height: Int = 1
            @SmallNumber var width: Int = 1
        }

        let unitRectangle = UnitRectangle()
        print(unitRectangle.width, unitRectangle.height)


        struct NarrowRectangle {
            @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
            @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
        }

        var narrowRectangle = NarrowRectangle()
        print(narrowRectangle.height, narrowRectangle.width)

        narrowRectangle.height = 100
        narrowRectangle.width = 100
        print(narrowRectangle.height, narrowRectangle.width)


        struct MixedRectangle {
            @SmallNumber var height = 1
            @SmallNumber(maximum: 9) var width = 2
        }

        var mixedRectangle = MixedRectangle()
        print(mixedRectangle.height)

        mixedRectangle.height = 20
        print(mixedRectangle.height)
    case .thirdVersion:
        break
    }
}

@propertyWrapper
struct SmallNumber {
    private var number = 0
    var projectedValue = false
    
    var wrappedValue: Int {
        get {
            number
        }
        set {
            if newValue > 12 {
                projectedValue = true
                number = 12
            } else {
                projectedValue = false
                number = newValue
            }
        }
    }
}


struct SomeStructure {
    @SmallNumber var someNumber: Int
}

var someStructure = SomeStructure()
someStructure.someNumber = 4
print(someStructure.$someNumber)
someStructure.someNumber = 55
print(someStructure.$someNumber)


enum Size {
    case small, large
}

struct SizedRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
    
    mutating func resize(size: Size) -> Bool {
        switch size {
        case .small:
            height = 10
            width = 20
        case .large:
            height = 100
            width = 100
        }
        
        return $height || $width
    }
}

var sizedRectangle = SizedRectangle()
print(sizedRectangle.resize(size: .small))
print(sizedRectangle.resize(size: .large))
