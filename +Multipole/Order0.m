classdef Order0 < Multipole.Base
    
    methods (Access = protected)
        
        function res = BlockWith0(obj, vecAB)
            res = obj.Block00(vecAB);
        end
        
        function res = BlockWith1(obj, vecAB)
            res = obj.Block10(-vecAB)';
        end
        
        function res = BlockWith2(obj, vecAB)
            res = obj.Block20(-vecAB)';
        end
        
        function res = BlockWith3(obj, vecAB)
            res = obj.Block30(-vecAB)';
        end
        
        function res = BlockWith4(obj, vecAB)
            res = obj.Block40(-vecAB)';
        end
        
    end
    
end
