
---

## 1. Запускаем поды (namespace `default`)

```bash
kubectl run front-end-app          --image=nginx --labels role=front-end           --expose --port 80
kubectl run back-end-api-app       --image=nginx --labels role=back-end-api        --expose --port 80
kubectl run admin-front-end-app    --image=nginx --labels role=admin-front-end     --expose --port 80
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api  --expose --port 80
```

---

## 2. Проверка 

```bash
kubectl apply -f task5-network-policies.yaml
```

```bash
# OK: front-end  -> back-end-api
kubectl run --rm -i --restart=Never --image=curlimages/curl test \
  -- curl -s --max-time 2 http://back-end-api-app && echo "OK"

# OK: admin-front-end  -> admin-back-end-api
kubectl run --rm -i --restart=Never --image=curlimages/curl test \
  -- curl -s --max-time 2 http://admin-back-end-api-app && echo "OK"

# BLOCK: front-end  -> admin-back-end-api
kubectl run --rm -i --restart=Never --image=curlimages/curl test \
  -- curl -s --max-time 2 http://admin-back-end-api-app || echo "BLOCK"

# BLOCK: admin-front-end  -> back-end-api
kubectl run --rm -i --restart=Never --image=curlimages/curl test \
  -- curl -s --max-time 2 http://back-end-api-app || echo "BLOCK"
```



