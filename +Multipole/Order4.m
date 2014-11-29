classdef Order4 < Multipole.Base
    
    methods (Access = protected)
        
        function res = With0(obj, vecAB)
            res = obj.Block40(vecAB);
        end
        
        function res = With1(obj, vecAB)
            res = obj.Block41(vecAB);
        end
        
        function res = With2(obj, vecAB)
            res = obj.Block42(vecAB);
        end
        
        function res = With3(obj, vecAB)
            res = obj.Block43(vecAB);
        end
        
        function res = With4(obj, vecAB)
            res = obj.Block44(vecAB);
        end
        
    end
    
end
