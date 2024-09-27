Attribute VB_Name = "Module1"
Sub ProcessSpecificWorksheets()
    Dim ws As Worksheet
    Dim sheetNames As Variant
    sheetNames = Array("A", "B", "C", "D", "E", "F")
    For Each ws In ActiveWorkbook.Worksheets
        ' Check if the current worksheet name is in the specified list
        If Not IsError(Application.Match(ws.Name, sheetNames, 0)) Then
            ws.Activate
            last_row = ws.Cells(Rows.Count, 1).End(xlUp).row
            ' Set headers
            Cells(1, 9).Value = "Ticker"
            Cells(1, 10).Value = "Quarterly Change"
            Cells(1, 11).Value = "Percent Change"
            Cells(1, 12).Value = "Total Stock Volume"
            Cells(1, 16).Value = "Ticker"
            Cells(1, 17).Value = "Value"
            Cells(2, 15).Value = "Greatest % Increase"
            Cells(3, 15).Value = "Greatest % Decrease"
            Cells(4, 15).Value = "Greatest Total Volume"
            ' Initialize variables
            Dim open_price As Double
            Dim close_price As Double
            Dim quarterly_change As Double
            Dim ticker As String
            Dim percent_change As Double
            Dim volume As Double
            Dim row As Double
            Dim column As Integer
            volume = 0
            row = 2
            column = 1
            open_price = Cells(2, column + 2).Value
            ' Main loop for processing data
            For i = 2 To last_row
                If Cells(i + 1, column).Value <> Cells(i, column).Value Then
                    ticker = Cells(i, column).Value
                    Cells(row, column + 8).Value = ticker
                    close_price = Cells(i, column + 5).Value
                    quarterly_change = close_price - open_price
                    Cells(row, column + 9).Value = quarterly_change
                    percent_change = quarterly_change / open_price
                    Cells(row, column + 10).Value = percent_change
                    Cells(row, column + 10).NumberFormat = "0.00%"
                    volume = volume + Cells(i, column + 6).Value
                    Cells(row, column + 11).Value = volume
                    row = row + 1
                    open_price = Cells(i + 1, column + 2).Value
                    volume = 0
                Else
                    volume = volume + Cells(i, column + 6).Value
                End If
            Next i
            ' Conditional formatting for Percent Change
            quarterly_change_last_row = ws.Cells(Rows.Count, 9).End(xlUp).row
            For j = 2 To quarterly_change_last_row
                If (Cells(j, 10).Value > 0 Or Cells(j, 10).Value = 0) Then
                    Cells(j, 10).Interior.ColorIndex = 4 ' Green for positive or zero
                ElseIf Cells(j, 10).Value < 0 Then
                    Cells(j, 10).Interior.ColorIndex = 3 ' Red for negative
                End If
            Next j
            ' Identify greatest values
            For k = 2 To quarterly_change_last_row
                If Cells(k, 11).Value = Application.WorksheetFunction.Max(ws.Range("K2:K" & quarterly_change_last_row)) Then
                    Cells(2, 16).Value = Cells(k, 9).Value
                    Cells(2, 17).Value = Cells(k, 11).Value
                    Cells(2, 17).NumberFormat = "0.00%"
                ElseIf Cells(k, 11).Value = Application.WorksheetFunction.Min(ws.Range("K2:K" & quarterly_change_last_row)) Then
                    Cells(3, 16).Value = Cells(k, 9).Value
                    Cells(3, 17).Value = Cells(k, 11).Value
                    Cells(3, 17).NumberFormat = "0.00%"
                ElseIf Cells(k, column + 11).Value = Application.WorksheetFunction.Max(ws.Range("L2:L" & quarterly_change_last_row)) Then
                    Cells(4, 16).Value = Cells(k, 9).Value
                    Cells(4, 17).Value = Cells(k, 12).Value
                End If
            Next k
            ' Format and autofit
            ActiveSheet.Range("I:Q").Font.Bold = True
            ActiveSheet.Range("I:Q").EntireColumn.AutoFit
        End If
    Next ws
End Sub
