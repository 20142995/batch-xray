from flask import Flask, request
import requests
import datetime
import logging

app = Flask(__name__)


def push_ftqq(content):
    resp = requests.post("https://sc.ftqq.com/.send",
                  data={"text": "xray vuln alarm", "desp": content})
    if resp.json()["errno"] != 0:
        raise ValueError("push ftqq failed, %s" % resp.text)

@app.route('/webhook', methods=['POST'])
def xray_webhook():
    vuln = request.json
    # 因为还会收到 https://chaitin.github.io/xray/#/api/statistic 的数据
    if vuln['type'] == 'web_statistic':
        return "ok"
    content = """## xray 发现了新漏洞\nurl: {url}\n插件: {plugin}\n漏洞类型: {vuln_class}\n发现时间: {create_time}\n请及时查看和处理""".format(url=vuln["data"]["target"]["url"], plugin=vuln["data"]["plugin"],
           vuln_class=vuln["data"]["plugin"],
           create_time=str(datetime.datetime.fromtimestamp(vuln["data"]["create_time"] / 1000)))
    try:
        push_ftqq(content)
    except Exception as e:
        logging.exception(e)
    return 'ok'


if __name__ == '__main__':
    app.run()
