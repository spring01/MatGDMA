classdef (Abstract) Base < handle
    
    methods
        
        function res = WithMaxOrder(obj, vecAB, maxOrderPlus1)
            switch(maxOrderPlus1)
                case(1)
                    res = obj.With0(vecAB);
                case(2)
                    res = [obj.With0(vecAB) ...
                        obj.With1(vecAB)];
                case(3)
                    res = [obj.With0(vecAB) ...
                        obj.With1(vecAB) ...
                        obj.With2(vecAB)];
                case(4)
                    res = [obj.With0(vecAB) ...
                        obj.With1(vecAB) ...
                        obj.With2(vecAB) ...
                        obj.With3(vecAB)];
                case(5)
                    res = [obj.With0(vecAB) ...
                        obj.With1(vecAB) ...
                        obj.With2(vecAB) ...
                        obj.With3(vecAB) ...
                        obj.With4(vecAB)];
                otherwise
                    throw(MException('Base:WithMaxOrder', 'Order not implemented yet.'));
            end
        end
        
    end
    
    methods (Abstract, Access = protected)
        
        res = With0(obj, vecAB);
        res = With1(obj, vecAB);
        res = With2(obj, vecAB);
        res = With3(obj, vecAB);
        res = With4(obj, vecAB);
        
    end
    
    methods (Access = protected)
        
        res = Block00(~, ~);
        res = Block10(~, vecZYX);
        res = Block11(~, vecZYX);
        res = Block20(~, vecZYX);
        res = Block21(~, vecZYX);
        res = Block22(~, vecZYX);
        res = Block30(~, vecZYX);
        res = Block31(~, vecZYX);
        res = Block32(~, vecZYX);
        res = Block33(~, vecZYX);
        res = Block40(~, vecZYX);
        res = Block41(~, vecZYX);
        res = Block42(~, vecZYX);
        res = Block43(~, vecZYX);
        res = Block44(~, vecZYX);
        
    end
    
end