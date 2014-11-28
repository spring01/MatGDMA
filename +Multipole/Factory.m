classdef Factory < handle
    
    methods (Static)
        
        function multipole = Create(order)
            switch(order)
                case(0)
                    multipole = Multipole.Order0();
                case(1)
                    multipole = Multipole.Order1();
                case(2)
                    multipole = Multipole.Order2();
                case(3)
                    multipole = Multipole.Order3();
                case(4)
                    multipole = Multipole.Order4();
                otherwise
                    throw(MException('Factory:Create', 'order not implemented yet.'));
            end
        end
        
    end
    
end