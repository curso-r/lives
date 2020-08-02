from selenium import webdriver
sess = webdriver.Firefox(executable_path="/home/jt/Downloads/geckodriver")
u = "http://divulgacandcontas.tse.jus.br/divulga/#/candidato/2018/2022802018/BR/280000614517"
sess.get(u)
obj = sess.page_source
