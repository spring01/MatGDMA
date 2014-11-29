classdef Order0 < Multipole.Base
    
    methods (Access = protected)
        
        function res = With0(obj, vecAB)
            res = obj.Block00(vecAB);
        end
        
        function res = With1(obj, vecAB)
            res = obj.Block10(-vecAB)';
        end
        
        function res = With2(obj, vecAB)
            res = obj.Block20(-vecAB)';
        end
        
        function res = With3(obj, vecAB)
            res = obj.Block30(-vecAB)';
        end
        
        function res = With4(obj, vecAB)
            res = obj.Block40(-vecAB)';
        end
        
    end
    
end
