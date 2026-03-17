#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Event")

; ============================================================
;  DICKBUTT DRAWER - AutoHotkey v2
;  F4 = draw with RMB held per-stroke (for games/apps)
;  F5 = draw with LMB only (for Paint testing)
;  Escape = abort mid-draw
; ============================================================

scale     := 1.5   ; Size multiplier (1.0 = ~300x335px)
drawSpeed := 2     ; Mouse move speed (0=instant, 100=slow)
ptDelay   := 5     ; ms pause between waypoints
abortDraw := false
rmbMode   := false ; Tracks whether we're in RMB mode

Escape:: {
    global abortDraw := true
}

F4:: {
    global abortDraw := false
    global rmbMode := true
    DrawDickButt()
}

F5:: {
    global abortDraw := false
    global rmbMode := false
    DrawDickButt()
}

DrawDickButt() {
    MouseGetPos(&ox, &oy)

    ; === OUTER SILHOUETTE (body+legs+butt+penis, traced from image) ===
    S(ox, oy, "96,40|40,78|32,90|38,117|27,174|32,196|57,261|83,279|75,302|56,293|50,294|60,319|80,332|106,286|147,287|144,295|129,297|127,303|140,323|159,334|166,322|172,283|201,279|233,240|260,229|258,217|251,212|260,197|241,191|255,137|248,130|232,131|204,181|179,177|151,189|153,114|143,61|132,46|96,40")

    ; === INNER BODY EDGE (eye sockets + internal shape) ===
    S(ox, oy, "101,47|120,52|140,78|144,199|139,199|151,203|154,195|177,185|200,188|196,196|168,204|167,212|204,207|219,218|225,232|224,244|204,268|165,279|158,325|136,304|150,304|157,281|107,278|77,267|56,243|39,196|36,172|42,133|124,122|44,124|45,110|59,109|61,117|86,110|81,104|69,110|85,90|76,92|64,72|101,47")

    ; === EYE LARGE (right eye outline) ===
    S(ox, oy, "101,81|97,86|94,95|94,107|99,113|105,115|120,114|126,113|131,109|135,103|138,93|136,85|133,81|130,79|123,77|110,77|101,81")

    ; === PUPIL RIGHT ===
    S(ox, oy, "120,81|126,86|130,91|132,96|132,101|130,105|125,107|110,108|110,106|119,102|123,97|123,90|119,82|120,81")

    ; === PUPIL LEFT ===
    S(ox, oy, "61,78|65,81|69,88|70,94|69,96|64,100|61,101|55,101|54,100|59,95|62,89|62,83|60,79|61,78")

    ; === PENIS SHAPE (outer contour of shaft+tip) ===
    S(ox, oy, "237,134|246,137|249,150|227,194|237,197|248,197|254,202|249,208|237,209|249,216|255,223|252,230|242,233|234,232|231,219|225,209|215,201|202,196|223,163|237,134")

    ; === ARMS/HANDS (both arms with hand details) ===
    S(ox, oy, "110,154|106,159|109,217|99,237|119,246|126,235|134,236|137,227|124,215|129,162|123,156|118,210|121,219|132,230|130,233|120,228|118,240|112,234|102,235|113,223|114,163|110,154")

    ; === LEFT FOOT DETAIL ===
    S(ox, oy, "100,284|100,285|83,317|76,325|73,325|63,314|56,303|54,298|59,298|78,309|84,298|90,283|93,282")

    ; === BUTT DOTS ===
    S(ox, oy, "167,193|166,195|171,199|175,200|178,196|176,193|172,192|167,193")
    S(ox, oy, "178,238|175,238|172,242|172,244|174,249|176,248|179,244|179,240|178,238")
    S(ox, oy, "184,219|181,223|181,227|186,228|189,227|187,220|184,219")
    S(ox, oy, "177,253|177,256|179,258|182,258|185,255|184,253|177,252|177,253")
    S(ox, oy, "188,263|187,265|190,268|193,269|193,266|190,262|188,263")
    S(ox, oy, "166,206|163,208|161,210|162,212|165,211|166,210|166,206")

    ToolTip("Done!")
    SetTimer(() => ToolTip(), -800)
}

; ---------------------------------------------------------------
; S() - Draw one stroke.
;   In RMB mode: press RMB, draw with LMB, release both, between each stroke.
;   In LMB mode: just draw with LMB.
; ---------------------------------------------------------------
S(ox, oy, pointStr) {
    global scale, drawSpeed, ptDelay, abortDraw, rmbMode
    if abortDraw
        return

    pts := StrSplit(pointStr, "|")

    ; Move to first point without drawing
    c := StrSplit(pts[1], ",")
    MouseMove(ox + Round(c[1] * scale), oy + Round(c[2] * scale), 0)
    Sleep(50)

    ; Press RMB first if in RMB mode
    if rmbMode {
        Click("Down Right")
        Sleep(30)
    }

    ; Hold LMB to draw this stroke
    SendEvent("{LButton Down}")
    Sleep(30)

    ; Trace through all points
    for pt in pts {
        if abortDraw {
            SendEvent("{LButton Up}")
            if rmbMode
                Click("Up Right")
            return
        }
        c := StrSplit(pt, ",")
        MouseMove(ox + Round(c[1] * scale), oy + Round(c[2] * scale), drawSpeed)
        Sleep(ptDelay)
    }

    ; Release LMB
    SendEvent("{LButton Up}")
    Sleep(20)

    ; Release RMB between strokes
    if rmbMode {
        Click("Up Right")
        Sleep(30)
    }
}
