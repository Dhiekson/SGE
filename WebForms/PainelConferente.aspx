<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PainelConferente.aspx.vb" Inherits="SGE.PainelConferente" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Painel do Conferente</title>
    <style>
        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
            margin: 0;
            padding: 0;
            color: #333;
        }

        .header {
            background: #1f2937;
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .header .usuario-info {
            font-size: 17px;
            font-weight: 500;
        }

        .container {
            max-width: 850px;
            margin: 80px auto;
            padding: 40px 50px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: all 0.3s ease;
        }

        .container:hover {
            transform: translateY(-3px);
            box-shadow: 0 14px 30px rgba(0, 0, 0, 0.12);
        }

        h2 {
            font-size: 26px;
            margin-bottom: 30px;
            color: #1f2937;
            letter-spacing: 0.5px;
        }

        .btn {
            display: inline-block;
            margin: 15px;
            padding: 14px 40px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            color: #fff;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.3);
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(37, 99, 235, 0.4);
        }

        .btn-logout {
            background: linear-gradient(135deg, #ef4444, #b91c1c);
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.3);
        }

        .btn-logout:hover {
            box-shadow: 0 6px 18px rgba(239, 68, 68, 0.4);
        }

        footer {
            text-align: center;
            margin-top: 80px;
            padding: 20px;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="usuario-info">
                <asp:Label ID="lblNomeUsuario" runat="server" Text=""></asp:Label> — 
                <asp:Label ID="lblPerfilUsuario" runat="server" Text=""></asp:Label>
            </div>
            <asp:Button ID="btnSair" runat="server" Text="Sair" CssClass="btn btn-logout" OnClick="btnSair_Click" />
        </div>

        <div class="container">
            <h2>Bem-vindo ao Painel do Conferente</h2>
            <asp:Button ID="btnConferirPedidos" runat="server" Text="Conferir Pedidos" CssClass="btn" OnClick="btnConferirPedidos_Click" />
        </div>

        <footer>
            &copy; <%: DateTime.Now.Year %> Sistema de Gestão de Estoque — Conferente
        </footer>
    </form>
</body>
</html>
