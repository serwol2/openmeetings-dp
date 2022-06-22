
Openmeetings - система для проведения видеоконференций.
Сайт проекта: https://openmeetings.apache.org/

Перед запуском github action в этом репозитории необходимо развернуть инфраструктуру 
запустив terraform-код из репозитория  https://github.com/serwol2/tf-om-dp

Здесь создается docker-image с openmeetings версии 7.0.0, запускается вариант для тестирования в
отдельном EC2 инстансе и после merge в main образ деплоится на AWS ECS, 
где происходит rolling update
