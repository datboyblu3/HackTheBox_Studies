Module Module1

    Sub Main()
        Dim Config As ConfigFile = ConfigFile.LoadFromFile("RU_Config.xml")
        Dim test As New SsoIntegration With {.Username = Config.Username, .Password = "fTEzAfYDoz1YzkqhQkH6GQFYKp1XY5hm7bjOP86yYxE="}
       


    End Sub

End Module
