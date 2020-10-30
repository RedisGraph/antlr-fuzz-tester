/**
 * Copyright (c) 2015-2020 "Neo Technology,"
 * Network Engine for Objects in Lund AB [http://neotechnology.com]
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * Attribution Notice under the terms of the Apache License 2.0
 * 
 * This work was created by the collective efforts of the openCypher community.
 * Without limiting the terms of Section 6, any Derivative Work that is not
 * approved by the public consensus process of the openCypher Implementers Group
 * should not be described as “Cypher” (and Cypher® is a registered trademark of
 * Neo4j Inc.) or as "openCypher". Extensions by implementers or prototypes or
 * proposals for change that have been documented or implemented should only be
 * described as "implementation extensions to Cypher" or as "proposed changes to
 * Cypher that are not yet approved by the openCypher community".
 */
grammar Cypher;

oC_Cypher
      :  SP? oC_Statement ( SP? ';' )? SP? EOF ;

oC_Statement
         :  oC_Query ;

oC_Query
     :  oC_RegularQuery
         | oC_StandaloneCall
         ;

oC_RegularQuery
            :  oC_SingleQuery ( SP? oC_Union )* ;

oC_Union
     :  ( UNION SP ALL SP? oC_SingleQuery )
         | ( UNION SP? oC_SingleQuery )
         ;

UNION : ('U') ('N') ('I') ('O') ('N')  ;

ALL : ('A') ('L') ('L')  ;

oC_SingleQuery
           :  oC_SinglePartQuery
               | oC_MultiPartQuery
               ;

oC_SinglePartQuery
               :  ( ( oC_ReadingClause SP? )* oC_Return )
                   | ( ( oC_ReadingClause SP? )* oC_UpdatingClause ( SP? oC_UpdatingClause )* ( SP? oC_Return )? )
                   ;

oC_MultiPartQuery
              :  ( ( oC_ReadingClause SP? )* ( oC_UpdatingClause SP? )* oC_With SP? )+ oC_SinglePartQuery ;

oC_UpdatingClause
              :  oC_Create
                  | oC_Merge
                  | oC_Delete
                  | oC_Set
                  | oC_Remove
                  ;

oC_ReadingClause
             :  oC_Match
                 | oC_Unwind
                 | oC_InQueryCall
                 ;

oC_Match
     :  ( OPTIONAL SP )? MATCH SP? oC_Pattern ( SP? oC_Where )? ;

OPTIONAL : ('O') ('P') ('T') ('I') ('O') ('N') ('A') ('L')  ;

MATCH : ('M') ('A') ('T') ('C') ('H')  ;

oC_Unwind
      :  UNWIND SP? oC_Expression SP AS SP oC_Variable ;

UNWIND : ('U') ('N') ('W') ('I') ('N') ('D')  ;

AS : ('A') ('S')  ;

oC_Merge
     :  MERGE SP? oC_PatternPart ( SP oC_MergeAction )* ;

MERGE : ('M') ('E') ('R') ('G') ('E')  ;

oC_MergeAction
           :  ( ON SP MATCH SP oC_Set )
               | ( ON SP CREATE SP oC_Set )
               ;

ON : ('O') ('N')  ;

CREATE : ('C') ('R') ('E') ('A') ('T') ('E')  ;

oC_Create
      :  CREATE SP? oC_Pattern ;

oC_Set
   :  SET SP? oC_SetItem ( ',' oC_SetItem )* ;

SET : ('S') ('E') ('T')  ;

oC_SetItem
       :  ( oC_PropertyExpression SP? '=' SP? oC_Expression )
           | ( oC_Variable SP? '=' SP? oC_Expression )
           | ( oC_Variable SP? '+=' SP? oC_Expression )
           | ( oC_Variable SP? oC_NodeLabels )
           ;

oC_Delete
      :  ( DETACH SP )? DELETE SP? oC_Expression ( SP? ',' SP? oC_Expression )* ;

DETACH : ('D') ('E') ('T') ('A') ('C') ('H')  ;

DELETE : ('D') ('E') ('L') ('E') ('T') ('E')  ;

oC_Remove
      :  REMOVE SP oC_RemoveItem ( SP? ',' SP? oC_RemoveItem )* ;

REMOVE : ('R') ('E') ('M') ('O') ('V') ('E')  ;

oC_RemoveItem
          :  ( oC_Variable oC_NodeLabels )
              | oC_PropertyExpression
              ;

oC_InQueryCall
           :  CALL SP oC_ExplicitProcedureInvocation ( SP? YIELD SP oC_YieldItems )? ;

CALL : ('C') ('A') ('L') ('L')  ;

YIELD : ('Y') ('I') ('E') ('L') ('D')  ;

oC_StandaloneCall
              :  CALL SP ( oC_ExplicitProcedureInvocation | oC_ImplicitProcedureInvocation ) ( SP YIELD SP oC_YieldItems )? ;

oC_YieldItems
          :  ( '*' | ( oC_YieldItem ( SP? ',' SP? oC_YieldItem )* ) ) ( SP? oC_Where )? ;

oC_YieldItem
         :  ( oC_ProcedureResultField SP AS SP )? oC_Variable ;

oC_With
    :  WITH oC_ProjectionBody ( SP? oC_Where )? ;

WITH : ('W') ('I') ('T') ('H')  ;

oC_Return
      :  RETURN oC_ProjectionBody ;

RETURN : ('R') ('E') ('T') ('U') ('R') ('N')  ;

oC_ProjectionBody
              :  ( SP? DISTINCT )? SP oC_ProjectionItems ( SP oC_Order )? ( SP oC_Skip )? ( SP oC_Limit )? ;

DISTINCT : ('D') ('I') ('S') ('T') ('I') ('N') ('C') ('T')  ;

oC_ProjectionItems
               :  ( '*' ( SP? ',' SP? oC_ProjectionItem )* )
                   | ( oC_ProjectionItem ( SP? ',' SP? oC_ProjectionItem )* )
                   ;

oC_ProjectionItem
              :  ( oC_Expression SP AS SP oC_Variable )
                  | oC_Expression
                  ;

oC_Order
     :  ORDER SP BY SP oC_SortItem ( ',' SP? oC_SortItem )* ;

ORDER : ('O') ('R') ('D') ('E') ('R')  ;

BY : ('B') ('Y')  ;

oC_Skip
    :  L_SKIP SP oC_Expression ;

L_SKIP : ('S') ('K') ('I') ('P')  ;

oC_Limit
     :  LIMIT SP oC_Expression ;

LIMIT : ('L') ('I') ('M') ('I') ('T')  ;

oC_SortItem
        :  oC_Expression ( SP? ( ASCENDING | ASC | DESCENDING | DESC ) )? ;

ASCENDING : ('A') ('S') ('C') ('E') ('N') ('D') ('I') ('N') ('G')  ;

ASC : ('A') ('S') ('C')  ;

DESCENDING : ('D') ('E') ('S') ('C') ('E') ('N') ('D') ('I') ('N') ('G')  ;

DESC : ('D') ('E') ('S') ('C')  ;

oC_Where
     :  WHERE SP oC_Expression ;

WHERE : ('W') ('H') ('E') ('R') ('E')  ;

oC_Pattern
       :  oC_PatternPart ( SP? ',' SP? oC_PatternPart )* ;

oC_PatternPart
           :  ( oC_Variable SP? '=' SP? oC_AnonymousPatternPart )
               | oC_AnonymousPatternPart
               ;

oC_AnonymousPatternPart
                    :  oC_PatternElement ;

oC_PatternElement
              :  ( oC_NodePattern ( SP? oC_PatternElementChain )* )
                  | ( '(' oC_PatternElement ')' )
                  ;

oC_NodePattern
           :  '(' SP? ( oC_Variable SP? )? ( oC_NodeLabels SP? )? ( oC_Properties SP? )? ')' ;

oC_PatternElementChain
                   :  oC_RelationshipPattern SP? oC_NodePattern ;

oC_RelationshipPattern
                   :  ( oC_LeftArrowHead SP? oC_Dash SP? oC_RelationshipDetail? SP? oC_Dash SP? oC_RightArrowHead )
                       | ( oC_LeftArrowHead SP? oC_Dash SP? oC_RelationshipDetail? SP? oC_Dash )
                       | ( oC_Dash SP? oC_RelationshipDetail? SP? oC_Dash SP? oC_RightArrowHead )
                       | ( oC_Dash SP? oC_RelationshipDetail? SP? oC_Dash )
                       ;

oC_RelationshipDetail
                  :  '[' SP? ( oC_Variable SP? )? ( oC_RelationshipTypes SP? )? oC_RangeLiteral? ( oC_Properties SP? )? ']' ;

oC_Properties
          :  oC_MapLiteral
              | oC_Parameter
              ;

oC_RelationshipTypes
                 :  ':' SP? oC_RelTypeName ( SP? '|' ':'? SP? oC_RelTypeName )* ;

oC_NodeLabels
          :  oC_NodeLabel ( SP? oC_NodeLabel )* ;

oC_NodeLabel
         :  ':' SP? oC_LabelName ;

oC_RangeLiteral
            :  '*' SP? ( oC_IntegerLiteral SP? )? ( '..' SP? ( oC_IntegerLiteral SP? )? )? ;

oC_LabelName
         :  oC_SchemaName ;

oC_RelTypeName
           :  oC_SchemaName ;

oC_Expression
          :  oC_OrExpression ;

oC_OrExpression
            :  oC_XorExpression ( SP OR SP oC_XorExpression )* ;

OR : ('O') ('R')  ;

oC_XorExpression
             :  oC_AndExpression ( SP XOR SP oC_AndExpression )* ;

XOR : ('X') ('O') ('R')  ;

oC_AndExpression
             :  oC_NotExpression ( SP AND SP oC_NotExpression )* ;

AND : ('A') ('N') ('D')  ;

oC_NotExpression
             :  ( NOT SP? )* oC_ComparisonExpression ;

NOT : ('N') ('O') ('T')  ;

oC_ComparisonExpression
                    :  oC_AddOrSubtractExpression ( SP? oC_PartialComparisonExpression )* ;

oC_AddOrSubtractExpression
                       :  oC_MultiplyDivideModuloExpression ( ( SP? '+' SP? oC_MultiplyDivideModuloExpression ) | ( SP? '-' SP? oC_MultiplyDivideModuloExpression ) )* ;

oC_MultiplyDivideModuloExpression
                              :  oC_PowerOfExpression ( ( SP? '*' SP? oC_PowerOfExpression ) | ( SP? '/' SP? oC_PowerOfExpression ) | ( SP? '%' SP? oC_PowerOfExpression ) )* ;

oC_PowerOfExpression
                 :  oC_UnaryAddOrSubtractExpression ( SP? '^' SP? oC_UnaryAddOrSubtractExpression )* ;

oC_UnaryAddOrSubtractExpression
                            :  ( ( '+' | '-' ) SP? )* oC_StringListNullOperatorExpression ;

oC_StringListNullOperatorExpression
                                :  oC_PropertyOrLabelsExpression ( oC_StringOperatorExpression | oC_ListOperatorExpression | oC_NullOperatorExpression )* ;

oC_ListOperatorExpression
                      :  ( SP IN SP? oC_PropertyOrLabelsExpression )
                          | ( SP? '[' oC_Expression ']' )
                          | ( SP? '[' oC_Expression? '..' oC_Expression? ']' )
                          ;

IN : ('I') ('N')  ;

oC_StringOperatorExpression
                        :  ( ( SP STARTS SP WITH ) | ( SP ENDS SP WITH ) | ( SP CONTAINS ) ) SP? oC_PropertyOrLabelsExpression ;

STARTS : ('S') ('T') ('A') ('R') ('T') ('S')  ;

ENDS : ('E') ('N') ('D') ('S')  ;

CONTAINS : ('C') ('O') ('N') ('T') ('A') ('I') ('N') ('S')  ;

oC_NullOperatorExpression
                      :  ( SP IS SP NULL )
                          | ( SP IS SP NOT SP NULL )
                          ;

IS : ('I') ('S')  ;

NULL : ('N') ('U') ('L') ('L')  ;

oC_PropertyOrLabelsExpression
                          :  oC_Atom ( SP? oC_PropertyLookup )* ( SP? oC_NodeLabels )? ;

oC_Atom
    :  oC_Literal
        | oC_Parameter
        | oC_CaseExpression
        | ( COUNT SP? '(' SP? '*' SP? ')' )
        | oC_ListComprehension
        | oC_PatternComprehension
        | ( ALL SP? '(' SP? oC_FilterExpression SP? ')' )
        | ( ANY SP? '(' SP? oC_FilterExpression SP? ')' )
        | ( NONE SP? '(' SP? oC_FilterExpression SP? ')' )
        | ( SINGLE SP? '(' SP? oC_FilterExpression SP? ')' )
        | oC_RelationshipsPattern
        | oC_ParenthesizedExpression
        | oC_FunctionInvocation
        | oC_Variable
        ;

COUNT : ('C') ('O') ('U') ('N') ('T')  ;

ANY : ('A') ('N') ('Y')  ;

NONE : ('N') ('O') ('N') ('E')  ;

SINGLE : ('S') ('I') ('N') ('G') ('L') ('E')  ;

oC_Literal
       :  oC_NumberLiteral
           | StringLiteral
           | oC_BooleanLiteral
           | NULL
           | oC_MapLiteral
           | oC_ListLiteral
           ;

oC_BooleanLiteral
              :  TRUE
                  | FALSE
                  ;

TRUE : ('T') ('R') ('U') ('E')  ;

FALSE : ('F') ('A') ('L') ('S') ('E')  ;

oC_ListLiteral
           :  '[' SP? ( oC_Expression SP? ( ',' SP? oC_Expression SP? )* )? ']' ;

oC_PartialComparisonExpression
                           :  ( '=' SP? oC_AddOrSubtractExpression )
                               | ( '<>' SP? oC_AddOrSubtractExpression )
                               | ( '<' SP? oC_AddOrSubtractExpression )
                               | ( '>' SP? oC_AddOrSubtractExpression )
                               | ( '<=' SP? oC_AddOrSubtractExpression )
                               | ( '>=' SP? oC_AddOrSubtractExpression )
                               ;

oC_ParenthesizedExpression
                       :  '(' SP? oC_Expression SP? ')' ;

oC_RelationshipsPattern
                    :  oC_NodePattern ( SP? oC_PatternElementChain )+ ;

oC_FilterExpression
                :  oC_IdInColl ( SP? oC_Where )? ;

oC_IdInColl
        :  oC_Variable SP IN SP oC_Expression ;

oC_FunctionInvocation
                  :  oC_FunctionName SP? '(' SP? ( DISTINCT SP? )? ( oC_Expression SP? ( ',' SP? oC_Expression SP? )* )? ')' ;

oC_FunctionName
            :  ( oC_Namespace oC_SymbolicName )
                | EXISTS
                ;

EXISTS : ('E') ('X') ('I') ('S') ('T') ('S')  ;

oC_ExplicitProcedureInvocation
                           :  oC_ProcedureName SP? '(' SP? ( oC_Expression SP? ( ',' SP? oC_Expression SP? )* )? ')' ;

oC_ImplicitProcedureInvocation
                           :  oC_ProcedureName ;

oC_ProcedureResultField
                    :  oC_SymbolicName ;

oC_ProcedureName
             :  oC_Namespace oC_SymbolicName ;

oC_Namespace
         :  ( oC_SymbolicName '.' )* ;

oC_ListComprehension
                 :  '[' SP? oC_FilterExpression ( SP? '|' SP? oC_Expression )? SP? ']' ;

oC_PatternComprehension
                    :  '[' SP? ( oC_Variable SP? '=' SP? )? oC_RelationshipsPattern SP? ( WHERE SP? oC_Expression SP? )? '|' SP? oC_Expression SP? ']' ;

oC_PropertyLookup
              :  '.' SP? ( oC_PropertyKeyName ) ;

oC_CaseExpression
              :  ( ( CASE ( SP? oC_CaseAlternatives )+ ) | ( CASE SP? oC_Expression ( SP? oC_CaseAlternatives )+ ) ) ( SP? ELSE SP? oC_Expression )? SP? END ;

CASE : ('C') ('A') ('S') ('E')  ;

ELSE : ('E') ('L') ('S') ('E')  ;

END : ('E') ('N') ('D')  ;

oC_CaseAlternatives
                :  WHEN SP? oC_Expression SP? THEN SP? oC_Expression ;

WHEN : ('W') ('H') ('E') ('N')  ;

THEN : ('T') ('H') ('E') ('N')  ;

oC_Variable
        :  oC_SymbolicName ;

StringLiteral
             :  ( '"' ( StringLiteral_0 | EscapedChar )* '"' )
                 | ( '\'' ( StringLiteral_1 | EscapedChar )* '\'' )
                 ;

EscapedChar
           :  '\\' ('\\' | '\'' | '"' | ('B') | ('F') | ('N') | ('R') | ('T') | (('U') ( HexDigit HexDigit HexDigit HexDigit ) ) | (('U') (HexDigit HexDigit HexDigit HexDigit HexDigit HexDigit HexDigit HexDigit ) ) ) ;

oC_NumberLiteral
             :  oC_DoubleLiteral
                 | oC_IntegerLiteral
                 ;

oC_MapLiteral
          :  '{' SP? ( oC_PropertyKeyName SP? ':' SP? oC_Expression SP? ( ',' SP? oC_PropertyKeyName SP? ':' SP? oC_Expression SP? )* )? '}' ;

oC_Parameter
         :  '$' ( oC_SymbolicName | DecimalInteger ) ;

oC_PropertyExpression
                  :  oC_Atom ( SP? oC_PropertyLookup )+ ;

oC_PropertyKeyName
               :  oC_SchemaName ;

oC_IntegerLiteral
              :  HexInteger
                  | OctalInteger
                  | DecimalInteger
                  ;

HexInteger
          :  '0x' ( HexDigit )+ ;

DecimalInteger
              :  ZeroDigit
                  | ( NonZeroDigit ( Digit )* )
                  ;

OctalInteger
            :  ZeroDigit ( OctDigit )+ ;

HexLetter
         :  ('A')
             | ('B')
             | ('C')
             | ('D')
             | ('E')
             | ('F')
             ;

HexDigit
        :  Digit
            | HexLetter
            ;

Digit
     :  ZeroDigit
         | NonZeroDigit
         ;

NonZeroDigit
            :  NonZeroOctDigit
                | '8'
                | '9'
                ;

NonZeroOctDigit
               :  '1'
                   | '2'
                   | '3'
                   | '4'
                   | '5'
                   | '6'
                   | '7'
                   ;

OctDigit
        :  ZeroDigit
            | NonZeroOctDigit
            ;

ZeroDigit
         :  '0' ;

oC_DoubleLiteral
             :  ExponentDecimalReal
                 | RegularDecimalReal
                 ;

ExponentDecimalReal
                   :  ( ( Digit )+ | ( ( Digit )+ '.' ( Digit )+ ) | ( '.' ( Digit )+ ) ) ('E') '-'? ( Digit )+ ;

RegularDecimalReal
                  :  ( Digit )* '.' ( Digit )+ ;

oC_SchemaName
          :  oC_SymbolicName
              | oC_ReservedWord
              ;

oC_ReservedWord
            :  ALL
                | ASC
                | ASCENDING
                | BY
                | CREATE
                | DELETE
                | DESC
                | DESCENDING
                | DETACH
                | EXISTS
                | LIMIT
                | MATCH
                | MERGE
                | ON
                | OPTIONAL
                | ORDER
                | REMOVE
                | RETURN
                | SET
                | L_SKIP
                | WHERE
                | WITH
                | UNION
                | UNWIND
                | AND
                | AS
                | CONTAINS
                | DISTINCT
                | ENDS
                | IN
                | IS
                | NOT
                | OR
                | STARTS
                | XOR
                | FALSE
                | TRUE
                | NULL
                | CONSTRAINT
                | DO
                | FOR
                | REQUIRE
                | UNIQUE
                | CASE
                | WHEN
                | THEN
                | ELSE
                | END
                | MANDATORY
                | SCALAR
                | OF
                | ADD
                | DROP
                ;

CONSTRAINT : ('C') ('O') ('N') ('S') ('T') ('R') ('A') ('I') ('N') ('T')  ;

DO : ('D') ('O')  ;

FOR : ('F') ('O') ('R')  ;

REQUIRE : ('R') ('E') ('Q') ('U') ('I') ('R') ('E')  ;

UNIQUE : ('U') ('N') ('I') ('Q') ('U') ('E')  ;

MANDATORY : ('M') ('A') ('N') ('D') ('A') ('T') ('O') ('R') ('Y')  ;

SCALAR : ('S') ('C') ('A') ('L') ('A') ('R')  ;

OF : ('O') ('F')  ;

ADD : ('A') ('D') ('D')  ;

DROP : ('D') ('R') ('O') ('P')  ;

oC_SymbolicName
            :  EscapedSymbolicName
                | HexLetter
                | COUNT
                | FILTER
                | EXTRACT
                | ANY
                | NONE
                | SINGLE
                ;

FILTER : ('F') ('I') ('L') ('T') ('E') ('R')  ;

EXTRACT : ('E') ('X') ('T') ('R') ('A') ('C') ('T')  ;

/**
 * Any character except "`", enclosed within `backticks`. Backticks are escaped with double backticks.
 */
EscapedSymbolicName
                   :  ( '`' ( EscapedSymbolicName_0 )* '`' )+ ;

SP
  :  ( WHITESPACE )+ ;

WHITESPACE
          :  SPACE
              | Comment
              ;

Comment
       :  ( '/*' ( Comment_1 | ( '*' Comment_2 ) )* '*/' )
           | ( '//' ( Comment_3 )* CR? ( LF | EOF ) )
           ;

oC_LeftArrowHead
             :  '<'
                 | '\u27e8'
                 | '\u3008'
                 | '\ufe64'
                 | '\uff1c'
                 ;

oC_RightArrowHead
              :  '>'
                  | '\u27e9'
                  | '\u3009'
                  | '\ufe65'
                  | '\uff1e'
                  ;

oC_Dash
    :  '-'
        | '\u00ad'
        | '\u2010'
        | '\u2011'
        | '\u2012'
        | '\u2013'
        | '\u2014'
        | '\u2015'
        | '\u2212'
        | '\ufe58'
        | '\ufe63'
        | '\uff0d'
        ;

fragment FF : [\f] ;

fragment EscapedSymbolicName_0 : ~[`] ;

fragment RS : [\u001E] ;

fragment Comment_1 : ~[*] ;

fragment StringLiteral_1 : ~['\\] ;

fragment Comment_3 : ~[\n\r] ;

fragment Comment_2 : ~[/] ;

fragment GS : [\u001D] ;

fragment FS : [\u001C] ;

fragment CR : [\r] ;

fragment SPACE : [ ] ;

fragment TAB : [\t] ;

fragment StringLiteral_0 : ~["\\] ;

fragment LF : [\n] ;

fragment VT : [\u000B] ;

fragment US : [\u001F] ;

