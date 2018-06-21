package com.jsonnetplugin;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;
import com.jsonnetplugin.psi.JsonnetTypes;
import com.intellij.psi.TokenType;

%%

%class JsonnetLexer
%implements FlexLexer
%unicode
%function advance
%type IElementType
%eof{  return;
%eof}

EOL=\R
WHITE_SPACE=\s+

LINE_COMMENT="//".*
BLOCK_COMMENT="/"\*([^*]|\*+[^*/])*(\*+"/")?
DOUBLE_QUOTED_STRING=\"([^\\\"\r\n]|\\[^\r\n])*\"?
SINGLE_QUOTED_STRING='([^\\'\r\n]|\\[^\r\n])*'?
NUMBER=(-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]*)?)|Infinity|-Infinity|NaN
IDENTIFIER=[[:jletterdigit:]~!()*\-."/"@\^<>=]+

%%
<YYINITIAL> {
  {WHITE_SPACE}               { return WHITE_SPACE; }

  "{"                         { return L_CURLY; }
  "}"                         { return R_CURLY; }
  "["                         { return L_BRACKET; }
  "]"                         { return R_BRACKET; }
  ","                         { return COMMA; }
  ":"                         { return COLON; }
  "true"                      { return TRUE; }
  "false"                     { return FALSE; }
  "null"                      { return NULL; }

  {LINE_COMMENT}              { return LINE_COMMENT; }
  {BLOCK_COMMENT}             { return BLOCK_COMMENT; }
  {DOUBLE_QUOTED_STRING}      { return DOUBLE_QUOTED_STRING; }
  {SINGLE_QUOTED_STRING}      { return SINGLE_QUOTED_STRING; }
  {NUMBER}                    { return NUMBER; }
  {IDENTIFIER}                { return IDENTIFIER; }

}

[^] { return BAD_CHARACTER; }

//id=[_a-zA-Z][_a-zA-Z0-9]*
//escape=\\[\"\'\\\/bfnrt]
//string=\"([^\\\"]|{escape})*\"|\'([^\\\']|{escape})*\'|@\"([^\"]|\"\")*\"|@\'([^\']|\'\')*\'
//number=-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?



//CRLF=\R
//WHITE_SPACE=[\ \n\t\f]
//FIRST_VALUE_CHARACTER=[^ \n\f\\] | "\\"{CRLF} | "\\".
//VALUE_CHARACTER=[^\n\f\\] | "\\"{CRLF} | "\\".
//END_OF_LINE_COMMENT=("#"|"!")[^\r\n]*
//SEPARATOR=[:=]
//KEY_CHARACTER=[^:=\ \n\t\f\\] | "\\ "
//
//%state WAITING_VALUE
//
//%%
//
//<YYINITIAL> {END_OF_LINE_COMMENT}                           { yybegin(YYINITIAL); return JsonnetTypes.COMMENT; }
//
//<YYINITIAL> {KEY_CHARACTER}+                                { yybegin(YYINITIAL); return JsonnetTypes.KEY; }
//
//<YYINITIAL> {SEPARATOR}                                     { yybegin(WAITING_VALUE); return JsonnetTypes.SEPARATOR; }
//
//<WAITING_VALUE> {CRLF}({CRLF}|{WHITE_SPACE})+               { yybegin(YYINITIAL); return TokenType.WHITE_SPACE; }
//
//<WAITING_VALUE> {WHITE_SPACE}+                              { yybegin(WAITING_VALUE); return TokenType.WHITE_SPACE; }
//
//<WAITING_VALUE> {FIRST_VALUE_CHARACTER}{VALUE_CHARACTER}*   { yybegin(YYINITIAL); return JsonnetTypes.VALUE; }
//
//({CRLF}|{WHITE_SPACE})+                                     { yybegin(YYINITIAL); return TokenType.WHITE_SPACE; }
//
//.                                                           { return TokenType.BAD_CHARACTER; }