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
    | Aus:FAdr,ATri Ita:AVen,ATyr| FAdrSATri-Ven,ATri-Ven,AVenH,ATyrSAVenH | SFSS |
    | Aus:FAdr,ATri,AVie Ita:AVen,ATyr| FAdrSATri-Ven,ATri-Ven,AVie-Tyr,AVenH,ATyrSAVenH | SSFSF |
