import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";




actor Token {
    let owner:Principal=Principal.fromText("5izrv-hudv2-exqmr-caw5c-yanei-ficgc-tzfhf-uhxgu-zotbt-zm72o-iae");
    let totalSupply:Nat=1000000000;
    let symbol:Text="GN";
    Debug.print("hello");

    private stable var balancesEntries : [(Principal,Nat)]=[];
    private var balances=HashMap.HashMap<Principal,Nat>(1,Principal.equal,Principal.hash);
      if(balances.size() < 1){

         balances.put(owner,totalSupply);
        };

    public query func balanceOf(who:Principal):async Nat{
        let balance:Nat=switch( balances.get(who)) {
            case null 0;
            case (?result) result;

        };  
    return balance;
    };
    public query func getSymbol():async Text{
        return symbol;  
    };
    public shared(msg) func payOut():async Text{

        if(balances.get(msg.caller)==null){
            Debug.print(debug_show(msg.caller));
        let amount=10000;
        let result=await transfer(msg.caller,amount);
        return "Success";
           
        }else{
            return "already cliamed";
        }
    };

    public shared(msg) func transfer(to:Principal,amount:Nat):async Text{    
        let fromBalance=await balanceOf(msg.caller);
        if (fromBalance > amount){
            let newFromBalance:Nat= fromBalance-amount;
            balances.put(msg.caller,newFromBalance);
            let toBalance=await balanceOf(to);
            let newBalance=toBalance+amount;
            balances.put(to,newBalance);
           return "Success"
        }
        else{
            return "Insufficent funds"
        }

    };
    system func preupgrade(){
        balancesEntries:=Iter.toArray(balances.entries())
        
    };
    system func postupgrade(){
        balances:=HashMap.fromIter<Principal,Nat>(balancesEntries.vals(),1,Principal.equal,Principal.hash);
        if(balances.size() < 1){

         balances.put(owner,totalSupply);
        }
        
    };


}
