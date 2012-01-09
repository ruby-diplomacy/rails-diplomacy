Feature: adjudicator resolves orders
	In order to automatically run games for the rails-diplomacy website
	As a adjudicator
	I want to resolve orders

  Scenario Outline: Test case outline
    Given current state "<currentstate>"
    When I adjudicate a set of "<orders>"
    Then the "<adjudication>" should be correct. 
    
  Scenarios: Diplomacy Adjudicator Test Cases - Basic Checks
    | currentstate | orders | adjudication |
    | Eng:FNth | FNth-Pic | F |
    | Eng:ALiv | ALiv-Iri | F |
    | Ger:FKie | FKie-Mun | F |
    | Ger:FKie | FKie-Kie | F |
    
  Scenarios: Diplomacy Adjudicator Test Cases - Supports and Dislodges
    | currentstate | orders | adjudication |
    | Aus:FAdr,ATri Ita:AVen,ATyr | FAdrSATri-Ven,ATri-Ven,AVenH,ATyrSAVen | SFSS |
    | Aus:FAdr,ATri,AVie Ita:AVen,ATyr | FAdrSATri-Ven,ATri-Ven,AVie-Tyr,AVenH,ATyrSAVen | SSFSF |
    | Aus:FAdr,ATri Ita:AVen,FIon | FAdrSATri-Ven,ATri-Ven,AVenH,FIon-Adr | FFSF |
    | Ger:ABer,FKie Rus:FBal,APru | ABerSFKie,FKieSABer,FBalSAPru-Ber,APru-Ber | FSSF |
    | Ger:ABer,FKie,AMun Rus:FBal,APru | ABerSAMun-Sil,FKieSABer,AMun-Sil,FBalSAPru-Ber,APru-Ber | FSSSF |
    | Ger:ABer,FBal,FPru Rus:FLvn,FBot | ABer-Swe,FBalCABer-Swe,FPruSFBal,FLvn-Bal,FBotSFLvn-Bal | SSSFS |
    | Ger:FBal,FPru Rus:FLvn,FBot,AFin | FBal-Swe,FPruSFBal,FLvn-Bal,FBotSFLvn-Bal,AFin-Swe | FFSSF |
    | Aus:FIon,ASer,AAlb Tur:AGre,ABul | FIonH,ASerSAAlb-Gre,AAlb-Gre,AGre-Nap,ABulSAGre | SSSFF |
    | Ita:AVen,ATyr Aus:AAlb,ATri | AVen-Tri,ATyrSAVen-Tri,AAlbSATri-Ser,ATriH | SSFS |
    | Ger:ABer,FKie,AMun | ABerH,FKie-Ber,AMunSFKie-Ber | SFS |
    | Ger:ABer,FKie,AMun Rus:AWar | ABer-Pru,FKie-Ber,AMunSFKie-Ber,AWar-Pru | FFSF |
    | Aus:FTri,AVie Ita:AVen | FTriH,AVieSAVen-Tri,AVen-Tri | SSF |
    | Aus:FTri,AVie Ita:AVen,FApu | FTri-Adr,AVieSAVen-Tri,AVen-Tri,FApu-Adr | FSFF |
