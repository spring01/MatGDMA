classdef (Abstract) Base < handle
    
    methods
        
        function res = BlockWithMaxOrder(obj, vecAB, maxOrderPlus1)
            switch(maxOrderPlus1)
                case(1)
                    res = obj.BlockWith0(vecAB);
                case(2)
                    res = [obj.BlockWith0(vecAB) ...
                        obj.BlockWith1(vecAB)];
                case(3)
                    res = [obj.BlockWith0(vecAB) ...
                        obj.BlockWith1(vecAB) ...
                        obj.BlockWith2(vecAB)];
                case(4)
                    res = [obj.BlockWith0(vecAB) ...
                        obj.BlockWith1(vecAB) ...
                        obj.BlockWith2(vecAB) ...
                        obj.BlockWith3(vecAB)];
                case(5)
                    res = [obj.BlockWith0(vecAB) ...
                        obj.BlockWith1(vecAB) ...
                        obj.BlockWith2(vecAB) ...
                        obj.BlockWith3(vecAB) ...
                        obj.BlockWith4(vecAB)];
                otherwise
                    throw(MException('MultipoleAny:BlockWith', 'order not implemented yet.'));
            end
        end
        
    end
    
    methods (Abstract, Access = protected)
        
        res = BlockWith0(obj, vecAB);
        res = BlockWith1(obj, vecAB);
        res = BlockWith2(obj, vecAB);
        res = BlockWith3(obj, vecAB);
        res = BlockWith4(obj, vecAB);
        
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