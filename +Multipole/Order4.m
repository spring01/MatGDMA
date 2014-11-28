classdef Order4 < Multipole.Base
    
    methods (Access = protected)
        
        function res = BlockWith0(obj, vecAB)
            res = obj.Block40(vecAB);
        end
        
        function res = BlockWith1(obj, vecAB)
            res = obj.Block41(vecAB);
        end
        
        function res = BlockWith2(obj, vecAB)
            res = obj.Block42(vecAB);
        end
        
        function res = BlockWith3(obj, vecAB)
            res = obj.Block43(vecAB);
        end
        
        function res = BlockWith4(obj, vecAB)
            res = obj.Block44(vecAB);
        end
        
    end
    
end
