unit DrawCards;
interface
uses Graphics, Windows;

procedure DrawCard(Canvas: TCanvas;
                     Rect: TRect;
                     card: Shortint;
                 fontsize: Byte;
                    focus: Boolean = False;
                    cross: Boolean = False;
                     grey: Boolean = False;
                     mast: Boolean = True;
                 backfill: Boolean = True);

implementation

uses PokerCards, Math;

procedure DrawCard(Canvas: TCanvas; Rect: TRect; card: Shortint; fontsize: Byte;
                                    focus,cross,grey,mast,backfill: Boolean);
var sMast, sCost: TSize;
    M, C: Byte;
    cost: string;
    offsetLeft, offsetTop: Longint;
    oldRectLeft: Integer;
begin
  oldRectLeft := Rect.Left;
  if backfill then begin
     Canvas.Brush.Color := RGB(255,255,255);
     Canvas.FillRect(Rect);
  end;
  if focus then begin
     Canvas.Pen.Color := RGB(0,0,0);
     Canvas.Rectangle(Rect);
     Inc(Rect.Left); Inc(Rect.Top);
     Dec(Rect.Right);Dec(Rect.Bottom);
  end;

  if card in ISCARD then with Canvas do begin
     M := GetMast(card); C := GetCost(card);
     with Font do begin
        if M in [mHearts, mDiamonds] then Color := clRed else Color := clBlack;
        if grey then Color := RGB(200,200,200);
        Size := fontsize;
        Name := 'Symbol';
        if mast then sMast := TextExtent(Chr(167+M)) else sMast := TextExtent('');
        Name := 'MS Sans Serif';
     end;
     if C < c10 then
        cost := Chr(50 + C)
     else
        case C of
             c10:    cost := '10';
             cJack:  cost := 'J';
             cQueen: cost := 'Q';
             cKing:  cost := 'K';
             cAce:   cost := 'A';
        end;
     sCost := TextExtent(cost);
     offsetLeft := Rect.Left + Floor(((Rect.Right-Rect.Left) - (sMast.cx+sCost.cx))/2);
     offsetTop  := Rect.Top + Floor(((Rect.Bottom-Rect.Top)- Max(sMast.cy, sCost.cy))/2);
     TextRect(Rect, offsetLeft, offsetTop, cost);
     if mast then begin
        Rect.Left := offsetLeft+sCost.cx+1;
        Font.Name := 'Symbol';
        TextRect(Rect, Rect.Left, offsetTop, Chr(167+M));
     end;
  end;

  if cross then with Canvas do begin
     Pen.Color := RGB(0,0,0);
     Rect.Left := oldRectLeft;
     MoveTo(Rect.Left+1, Rect.Top+1);
     LineTo(Rect.Right-1, Rect.Bottom-1);
     MoveTo(Rect.Right-1, Rect.Top+1);
     LineTo(Rect.Left+1, Rect.Bottom-1);
  end;
end;

end.
 