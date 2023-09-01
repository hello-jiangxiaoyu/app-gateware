from locust import HttpUser, task, between

# locust -f ddos.py --run-time 1h --users 100 --spawn-rate 10 --html report.html
class MyUser(HttpUser):
    wait_time = between(1, 3) # 执行等待时间

    @task(3)  # 每个用户并发执行3个请求
    def access_endpoint(self):
        with self.client.get("/api/endpoint", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure("Request failed")

