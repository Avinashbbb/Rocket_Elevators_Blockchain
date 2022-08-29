//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RocketElevator is  ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
  using Strings for uint256;

  string baseURI;
  string public baseExtension = ".json";
  uint256 public cost = 0.01 ether;
  uint256 public maxSupply = 9;
  uint256 public maxMintAmount = 1;
  bool public paused = true;
  bool public revealed = false;
  string public notRevealedUri;
  address[] public whitelisted;


  constructor(
    // string memory _name,
    // string memory _symbol,
    // string memory _initBaseURI,
    // string memory _initNotRevealedUri
  ) ERC721("Rocketelevatorsnft", "NFT") {   
    // setBaseURI(_initBaseURI);
    // setNotRevealedURI(_initNotRevealedUri);
    whitelisted = [0x92A22470b1eC3DE435Da89E9f0B7183cEB2f3714,0x004660331dd96BfE95Ad4D32bf5EF7845a0Bc689,0xe578a5896931207AEb909Ba12EFc92b88422950a,0x4221ab4A5A1172FF48bB385d38fBa33453427957,0x4eeA12a0B97af76FaBDC91b76B1960173DC15e89,0x6c9e61363F48fEAc41f9a2469E54994Ce745E274,0xDf6EfD03c762374c1a840558dD9d3554B4fa3658,0x326a276b46BAaD8d1019fEd693B02ED0ad82FA01,0x78aDae76DB2FcC462Fe4AD58Eb2ED87a1bF05F9f,0x71c52f19d1cd0bC0a92663ab211E20a7a31Ad5BC];
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  function mint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    require(!paused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);

    if (msg.sender != owner()) {
        
      require(msg.value >= cost * _mintAmount);
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function safeMint(address to, uint256 tokenId) public  {
      for(uint256 i = 0; i < whitelisted.length; i++){
          if(to == whitelisted[i]){
        _safeMint(to, tokenId);
        }        
      }
      
    }

    function eligibility(address addr)public view returns (string memory) {
        for(uint256 i = 0; i < whitelisted.length; i++){
            if(addr == whitelisted[i]){
                return " Elegible";
            }
        }
         return " Not Elegible";
    }
    

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    if(revealed == false) {
        return notRevealedUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  //only owner
  function reveal() public onlyOwner() {
      revealed = true;
  }
  
  function setCost(uint256 _newCost) public onlyOwner() {
    cost = _newCost;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
    maxMintAmount = _newmaxMintAmount;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
  function withdraw() public payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success);
  }
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


}