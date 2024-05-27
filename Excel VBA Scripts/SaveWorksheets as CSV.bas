Public Sub SaveWorksheetsAsCsv()
    Dim xWs As Worksheet
    Dim xDir As String
    Dim folder As FileDialog
    Set folder = Application.FileDialog(msoFileDialogFolderPicker)
    If folder.Show <> -1 Then Exit Sub
        xDir = folder.SelectedItems(1)
    For Each xWs In Application.ActiveWorkbook.Worksheets
        xWs.Copy
        xcsvFile = xDir & "\" & xWs.Name
        Application.ActiveWorkbook.SaveAs Filename:=xcsvFile, _
        FileFormat:=xlCSVUTF8, CreateBackup:=False
        Application.ActiveWorkbook.Saved = True
        Application.ActiveWorkbook.Close
    Next
End Sub