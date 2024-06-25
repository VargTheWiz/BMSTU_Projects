
namespace KursovayaRyabSolAbr
{
    partial class MainPage
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label2 = new System.Windows.Forms.Label();
            this.create_con = new System.Windows.Forms.Button();
            this.join_chat = new System.Windows.Forms.Button();
            this.about = new System.Windows.Forms.Button();
            this.exit = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(235, 81);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(321, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Добро пожаловать в программу общения по кабелю RS-232c";
            // 
            // create_con
            // 
            this.create_con.Location = new System.Drawing.Point(145, 205);
            this.create_con.Name = "create_con";
            this.create_con.Size = new System.Drawing.Size(122, 23);
            this.create_con.TabIndex = 2;
            this.create_con.Text = "Создать";
            this.create_con.UseVisualStyleBackColor = true;
            this.create_con.Click += new System.EventHandler(this.create_con_Click);
            // 
            // join_chat
            // 
            this.join_chat.Location = new System.Drawing.Point(543, 205);
            this.join_chat.Name = "join_chat";
            this.join_chat.Size = new System.Drawing.Size(121, 23);
            this.join_chat.TabIndex = 3;
            this.join_chat.Text = "Присоединиться";
            this.join_chat.UseVisualStyleBackColor = true;
            this.join_chat.Click += new System.EventHandler(this.join_chat_Click);
            // 
            // about
            // 
            this.about.Location = new System.Drawing.Point(360, 327);
            this.about.Name = "about";
            this.about.Size = new System.Drawing.Size(75, 23);
            this.about.TabIndex = 4;
            this.about.Text = "Об авторах";
            this.about.UseVisualStyleBackColor = true;
            this.about.Click += new System.EventHandler(this.about_Click);
            // 
            // exit
            // 
            this.exit.Location = new System.Drawing.Point(329, 385);
            this.exit.Name = "exit";
            this.exit.Size = new System.Drawing.Size(140, 23);
            this.exit.TabIndex = 5;
            this.exit.Text = "Закрыть приложение";
            this.exit.UseVisualStyleBackColor = true;
            this.exit.Click += new System.EventHandler(this.exit_Click);
            // 
            // MainPage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.exit);
            this.Controls.Add(this.about);
            this.Controls.Add(this.join_chat);
            this.Controls.Add(this.create_con);
            this.Controls.Add(this.label2);
            this.Name = "MainPage";
            this.Text = "Главное Окно";
            this.Load += new System.EventHandler(this.Main_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button create_con;
        private System.Windows.Forms.Button join_chat;
        private System.Windows.Forms.Button about;
        private System.Windows.Forms.Button exit;
    }
}

