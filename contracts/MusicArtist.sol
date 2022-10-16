// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// import "@openzeppelin/contracts/access/Ownable.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";


contract MusicArtist is ERC1155,Ownable,Pausable{
    
using Counters for Counters.Counter;
Counters.Counter count;
//in the costructor we set up the initial nftId
//nft Id means idName[artistNft] = 1; which represents the Nft that will be 
//distributed for the artist when registered
    constructor()ERC1155(""){
        // string memory _idName = "artistRegistrationNft";
        // uint _idNumber = 1;
        //  NftIdDetails memory nftIdDetails = NftIdDetails(_idName,_idNumber);
        //  idName[_idName] = _idNumber;
        //  storeIdName.push(nftIdDetails);
    }

    error throwError(string,uint);
    uint256 artistRegistrationFee = 1 ether;

    struct NftIdDetails{
       string idName;
       uint idNo;
    }

    struct ArtistDetails{
       string name;
       address depositAddress;
    }
    mapping (string => uint) idName;
    mapping (uint=>NftIdDetails) idToNft;
    //array for storing Nft details
    NftIdDetails[] public storeNftDetails;
     //array for storing artist details
    ArtistDetails[] public storeArtistDetails; 


function addNftId(string memory _idName,uint _idNumber) external  onlyOwner returns(uint){

    // NftIdDetails memory nftIdDetails = NftIdDetails(_idName,_idNumber);
    // uint _count = count.current();
    // count.increment();
    idToNft[_idNumber] = NftIdDetails({
        idName:_idName,
        idNo:_idNumber
     });
    idName[_idName] = _idNumber;
    storeNftDetails.push(idToNft[_idNumber]);
    return idName[_idName];


}

// _idName = nftArtistRegistration _idNumber = 2334
function addNftIdBatch(string[] memory _idName,uint[] memory _idNumber) external  onlyOwner returns(NftIdDetails[] memory){
    require(_idName.length == _idNumber.length,"_idName and_idNumber are unequal");
    
    for(uint i;i<_idName.length;i++){
    idToNft[_idNumber[i]] = NftIdDetails({
        idName:_idName[i],
        idNo:_idNumber[i]
     });
    idName[_idName[i]] = _idNumber[i];
    storeNftDetails.push(idToNft[_idNumber[i]]);
    }


}

   function updateNftIdNames(uint _idNumber,string memory updatedNftIdName) external  onlyOwner returns(string memory) {
         if(idToNft[_idNumber].idNo!=_idNumber){
             revert throwError("there is no existing Nft id for this ",_idNumber);
         }

       string memory _oldNftIdName = idToNft[_idNumber].idName;
       idToNft[_idNumber].idName = updatedNftIdName;
       idName[updatedNftIdName] = idToNft[_idNumber].idNo;
       uint length = storeNftDetails.length;
       for(uint i;i<length;i++){
           if(storeNftDetails[i].idNo==_idNumber){
               storeNftDetails[i].idName = updatedNftIdName;
               break ;
           }
       }
       delete idName[_oldNftIdName];

        return idToNft[_idNumber].idName;


     }

function getNftIdDetails() external  onlyOwner returns (NftIdDetails[] memory){
    return storeNftDetails;
}

   function registrationAsUserOrAsArtis(string memory _artistName,address _depositAddress) public payable  {
       require(msg.value == artistRegistrationFee,"the registration fee for the artist is 1 Ether" );
       ArtistDetails memory register = ArtistDetails(_artistName,_depositAddress);
       storeArtistDetails.push(register);
       uint length = storeNftDetails.length;
       for(uint i;i<length;i++){
        //    if(idToNft[i].idName == )

       }
    //    _mint(_depositAddress, idName[], 1, "");
 }





  }