var Simple= artifacts.require("Hello");

module.exports=function(deployer){
    deployer.deploy(Simple);
};