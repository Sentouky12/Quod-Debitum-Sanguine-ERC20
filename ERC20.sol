//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.0;
// ----------------------------------------------------------------------------
// EIP-20: ERC-20 Token Standard
// https://eips.ethereum.org/EIPS/eip-20
// -----------------------------------------

 interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
     function approve(address spender, uint tokens) external returns (bool success);
     function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
     event Transfer(address indexed from, address indexed to, uint tokens);
     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
 
 contract QuodDebitumSanquine is ERC20Interface {
          string public name ="QuodDebitumSanquine";
          string public symbol="QDS";
          uint public decimals=0;
          uint public override totalSupply;

          address public Founder;
          mapping (address => uint256) public freezeOf;
          mapping(address=>uint) public balances;
          mapping(address => mapping(address => uint)) allowed;

    event Burn(address indexed from, uint256 value);
	
	/* This notifies clients about the amount frozen */
    event Freeze(address indexed from, uint256 value);
	
	/* This notifies clients about the amount unfrozen */
    event Unfreeze(address indexed from, uint256 value);

          constructor(){
              totalSupply=1000000;
              Founder=msg.sender;
              balances[Founder]=totalSupply;
             
              
          }
          function balanceOf(address tokenOwner) public view override returns (uint balance){
              return balances[tokenOwner];
          }
          function transfer(address to, uint tokens) public override returns (bool success){
              require(balances[msg.sender]>=tokens);
              balances[to]+=tokens;
              balances[msg.sender]-=tokens;
              emit Transfer(msg.sender,to,tokens);
              
              return true;
          
          }
             
             function allowance(address tokenOwner, address spender) public view override returns (uint){
                 return allowed[tokenOwner][spender];
             }

             function approve(address spender, uint tokens) public override returns (bool success){
                      require(balances[msg.sender]>=tokens);
                      require(tokens>0);
                      allowed[msg.sender][spender]=tokens;
                      emit Approval(msg.sender,spender,tokens);
                      return true;
             }

              function transferFrom(address from, address to, uint tokens) public override returns (bool success){
                       require(allowed[from][to]>=tokens);
                       require(balances[from]>=tokens);
                       balances[from]-=tokens;
                       balances[to]+=tokens;
                       allowed[from][to]-=tokens;

                       return true;
              }

          

           
  function burn(uint256 _value) public returns (bool success) {
        require (balances[msg.sender] > _value) ;           // Check if the sender has enough
		require (_value >= 0);
      balances[msg.sender] =balances[msg.sender]-_value;                   // Subtract from the sender
        totalSupply = totalSupply-_value;                            // Updates totalSupply
        emit Burn(msg.sender,_value);
        return true;
    }
	
	function freeze(uint256 _value) public returns (bool success) {
        require  (balances[msg.sender] >_value);           // Check if the sender has enough
		require  (_value >= 0);
        balances[msg.sender] = balances[msg.sender]-_value;                     // Subtract from the sender
        freezeOf[msg.sender] = freezeOf[msg.sender]+_value;     
        emit Freeze(msg.sender,_value);                       // Updates totalSupply
        return true;
    }
	
	function unfreeze(uint256 _value) public returns (bool success) {
        require  (freezeOf[msg.sender] >= _value);       // Check if the sender has enough
		require(_value >= 0);
        freezeOf[msg.sender] = freezeOf[msg.sender]-_value;                     // Subtract from the sender
		balances[msg.sender] = balances[msg.sender]+_value;
       emit Unfreeze(msg.sender,_value);
        return true;
    }

          

 }
 


