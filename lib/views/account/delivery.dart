import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import '../../models/delivery.dart';
import '../../other/constant.dart';
import '../header.dart';
import '../navigations.dart';

class DeliveryView extends StatefulWidget {
  const DeliveryView({super.key});

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  late final Box setting;
  final accordions = [
    Delivery(
        name: "Отправка товаров наложенным платежем с оплатой при получении",
        value: "Мы не требуем предоплаты за заказы и высылаем товар наложенным платежем с оплатой при получении в пункте выдачи вашего населеного пункта или на почте. Без всяких рисков для вас."
    ),
    Delivery(
        name: "Оплата банковской картой на сайте",
        value: '''<div class="answer">
	<p>Для выбора оплаты товара с помощью банковской карты на соответствующей странице необходимо нажать кнопку Оплата заказа банковской картой. Оплата происходит через ПАО СБЕРБАНК с использованием банковских карт следующих платёжных систем:</p>

	<ul>
		<li>МИР <img class="information-image" src="${siteUrl}catalog/view/theme/default/image/svg/mir-logo.svg">	</li>
		<li>VISA International <img class="information-image" src="${siteUrl}catalog/view/theme/default/image/svg/visa-logo.svg"></li>
		<li>Mastercard Worldwide <img class="information-image" src="${siteUrl}catalog/view/theme/default/image/svg/mastercard-logo.svg"></li>
		<li>JCB <img class="information-image" src="${siteUrl}catalog/view/theme/default/image/svg/jcb-logo.svg"></li>
	</ul>
	<p>Наш сайт подключен к интернет-эквайрингу, и Вы можете оплатить Товар банковской картой Visa, MasterCard, Maestro и МИР. После подтверждения выбранного Товара откроется защищенное окно с платежной страницей процессингового центра ПАО «Сбербанк», где Вам необходимо ввести данные Вашей банковской карты. Для дополнительной аутентификации держателя карты используется протокол 3D Secure. Если Ваш Банк поддерживает данную технологию, Вы будете перенаправлены на его сервер для дополнительной идентификации. Информацию о правилах и методах дополнительной идентификации уточняйте в Банке, выдавшем Вам банковскую карту.</p>

	<p><b>Гарантии безопасности</b></p>
	<p>Процессинговый центр ПАО «Сбербанк» защищает и обрабатывает данные Вашей банковской карты по стандарту безопасности PCI DSS 3.2. Передача информации в платежный шлюз происходит с применением технологии шифрования SSL. Дальнейшая передача информации происходит по закрытым банковским сетям, имеющим наивысший уровень надежности. ПАО «Сбербанк» не передает данные Вашей карты нам и иным третьим лицам. Для дополнительной аутентификации держателя карты используется протокол 3D Secure. В случае, если у Вас есть вопросы по совершенному платежу, Вы можете обратиться в службу поддержки клиентов платежного сервиса по электронной почте combox@sberbank.ru.</p>

	<p><b>Безопасность онлайн платежей</b></p>
	<p>Предоставляемая Вами персональная информация (имя, адрес, телефон, e-mail, номер кредитной карты) является конфиденциальной и не подлежит разглашению. Данные Вашей кредитной карты передаются только в зашифрованном виде и не сохраняются на нашем Web-сервере. Мы рекомендуем вам проверить, что ваш браузер достаточно безопасен для проведения платежей онлайн, на специальной странице. Безопасность обработки Интернет-платежей гарантирует ПАО «Сбербанк». Все операции с платежными картами происходят в соответствии с требованиями VISA International, MasterCard и других платежных систем. При передаче информации используются специальные технологии безопасности карточных онлайн-платежей, обработка данных ведется на безопасном высокотехнологичном сервере процессинговой компании.</p>

	<p><b>СЛУЧАИ ОТКАЗА В СОВЕРШЕНИИ ПЛАТЕЖА</b></p>
	<ul>
		<li>банковская карта не предназначена для совершения платежей через интернет, о чем можно узнать, обратившись в Ваш Банк;</li>
		<li>недостаточно средств для оплаты на банковской карте. Подробнее о наличии средств на банковской карте Вы можете узнать, обратившись в банк, выпустивший банковскую карту;</li>
		<li>данные банковской карты введены неверно;</li>
		<li>истек срок действия банковской карты. Срок действия карты, как правило, указан на лицевой стороне карты (это месяц и год, до которого действительна карта). Подробнее о сроке действия карты Вы можете узнать, обратившись в банк, выпустивший банковскую карту;</li>
	</ul>

	<p>По вопросам оплаты с помощью банковской карты и иным вопросам, связанным с работой сайта, Вы можете обращаться по бесплатному телефону: 8 (800) 101 14 40</p>

	<p>Предоставляемая вами персональная информация (имя, адрес, телефон, e-mail, номер банковской карты) является конфиденциальной и не подлежит разглашению. Данные вашей кредитной карты передаются только в зашифрованном виде и не сохраняются на нашем Web-сервере.</p>

	<p><b>ПРАВИЛА ВОЗВРАТА ТОВАРА</b></p>
	<p>При оплате картами возврат наличными денежными средствами не допускается. Порядок возврата регулируется правилами международных платежных систем. Процедура возврата товара регламентируется статьей 26.1 федерального закона «О защите прав потребителей». Потребитель вправе отказаться от товара в любое время до его передачи, а после передачи товара - в течение семи дней; Возврат товара надлежащего качества возможен в случае, если сохранены его товарный вид, потребительские свойства, а также документ, подтверждающий факт и условия покупки указанного товара; Потребитель не вправе отказаться от товара надлежащего качества, имеющего индивидуально-определенные свойства, если указанный товар может быть использован исключительно приобретающим его человеком; При отказе потребителя от товара продавец должен возвратить ему денежную сумму, уплаченную потребителем по договору, за исключением расходов продавца на доставку от потребителя возвращенного товара, не позднее чем через десять дней со дня предъявления потребителем соответствующего требования; Для возврата денежных средств на банковскую карту необходимо заполнить «Заявление о возврате денежных средств», которое высылается по требованию компанией на электронный адрес и оправить его вместе с приложением копии паспорта по адресу: zakaz@ohotika.ru. Возврат денежных средств будет осуществлен на банковскую карту в течение 21 (двадцати одного) рабочего дня со дня получения «Заявление о возврате денежных средств» Компанией. Для возврата денежных средств по операциям проведенными с ошибками необходимо обратиться с письменным заявлением и приложением копии паспорта и чеков/квитанций, подтверждающих ошибочное списание. Данное заявление необходимо направить по адресу: zakaz@ohotika.ru</p>
	</div>
	<p class="q">
	</p>
	<h2><span>Рассрочка от СберБанка <img src="${siteUrl}catalog/view/theme/default/image/Logo_sber_cvet.png" width="115px"></span><span class="mdi lnr lnr-chevron-down"></span><span class="mdi lnr lnr-chevron-up"></span></h2>
	<p> <b>Преимущества</b></p>
	<div class="answer">
	<p>Оформление в СберБанк Онлайн за несколько минут</p>

	<p> Никаких переплат и первого взноса</p>
    <p> Быстрое рассмотрение</p>

	<p><b>Требования к клиенту:</b></p>
	<ul>
	<li>Гражданство РФ</li>
	<li>Возраст от 18 до 70 лет</li>
	<li>Постоянная или временная регистрация на территории РФ</li>
	<li>Действующая дебетовая карта СберБанка</li>
	<li>СберБанк Онлайн и подключённые СМС-оповещения</li>
	</ul>
	<p><b>Как купить:</b></p>
	<ul><li>При оформлении заказа в качестве способа оплаты выберите «В рассрочку от СберБанка».</li>
	<li>В открывшемся окне «СберБанк Онлайн», авторизуйтесь и заполните заявку на оформление рассрочки. Рассмотрение занимает не более 2 мин.</li>
	<li>После того, как рассрочка будет одобрена, деньги за покупку автоматически перечислятся на наш счёт</li>
	</ul>
	<p><b>Условия рассрочки:</b></p>
	<ul>
	<li>Cумма  от 3 000 до 300 000 ₽</li>
	<li>Срок рассрочки  6 месяцев</li>
	</ul>
	<p>Подробнее на сайте <a href="https://www.sberbank.com/ru/person/credits/money/pos">https://www.sberbank.com/ru/person/credits/money/pos</a></p>

	</div>'''
    ),
    Delivery(
        name: "Осмотр заказа",
        value: "При доставке в пункты выдачи заказов, все товары можно осмотреть."
    ),
    Delivery(
        name: "Возврат и обмен товара",
        value: "Если товар не надлежащего качества, мы без проблем обменяем этот товар или вернём деньги. Для этого нужно всего лишь написать нам на почту или позвонить."
    ),
    Delivery(
        name: "Стоимость доставки на заказы суммой до 20000 рублей",
        value: "Стоимость доставки до пункта самовывоза по России и Чебоксарам при заказе до 20000 руб. фиксированная и составляет 390 рублей."
    ),
    Delivery(
        name: "Бесплатная доставка заказов стоимостью от 20000 рублей",
        value: "Стоимость доставки до пункта самовывоза по России и Чебоксарам при заказе от 20000 рублей БЕСПЛАТНАЯ."
    ),
    Delivery(
        name: "Способы доставки",
        value: "Мы работаем по всей России. Доставка осуществляется транспортными компаниями, СДЕК, Boxberry, DPD, а также Почтой России. Сроки доставки в среднем от 2 дней."
    ),
    Delivery(
        name: "Огромный ассортимент",
        value: "Огромное количество товаров для рыболовов, охотников и туристов представлено в нашем интернет-магазине Ohotika.ru и каталог товаров постоянно расширяется. Еженедельные обновления товаров практически во всех категориях."
    ),
    Delivery(
        name: "Весь товар от производителя ХСН Чебоксары",
        value: "Производство, склады и офисы находятся в городе Чебоксары. Именно оттуда мы отправляем все товары."
    ),
    Delivery(
        name: "Весь товар сертифицирован",
        value: "Весь товар имеет сертификаты качества и соответствия установленным нормам Российской Федерации. Мы очень дорожим нашими клиентами и своей репутацией, поэтому никогда не будем продавать товар без соответствующих документов."
    ),
    Delivery(
        name: "Низкие цены и отличное качество",
        value: "На 80% продукции мы не поднимали цены и стараемся делать всё возможное, чтобы цены оставались доступными для всех слоёв населения."
    ),
    Delivery(
        name: "Более 25 лет успешной работы",
        value: "Мы работаем с лидерами на рынке одежды, обуви и снаряжения для охоты, рыбалки, активного отдыха и силовых структур. За 25 лет активной работы удалось завоевать высокую репутацию среди клиентов, благодаря высокому качеству, долговечности продукции и оптимальному соотношению \"цена/качество\". Поэтому люди выбирают нас."
    )
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });

    super.initState();
  }

  setData() async {
    await Hive.initFlutter();
    setting = await Hive.openBox('setting');
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
        backgroundColor: const Color(0xFFEBF3FB),
        appBar: const HeaderView(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/left.svg", semanticsLabel: 'back', width: 15, height: 15),
                        SizedBox(
                          width: width - 25,
                          child: const Text(
                            "оплата и доставка",
                            style: TextStyle(
                              color: Color(0xFF23262C),
                              fontSize: 14,
                              fontFamily: 'DaysSansBlack',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(runSpacing: 5, children: List.generate(accordions.length, (index) {
                  return accordion(accordions[index]);
                })),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavigationView()
    );
  }

  Widget accordion(Delivery item) {
    final double width = MediaQuery.of(context).size.width - 20;
    var visible = false;

    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return Container(
          constraints: BoxConstraints(minHeight: 60, minWidth: width),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (!visible) {
                    visible = true;
                  } else {
                    visible = false;
                  }

                  state(() {});
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          item.name!,
                          style: const TextStyle(
                              color: Color(0xFF23262C),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                    SvgPicture.asset("assets/${!visible ? "down" : "up"}.svg", semanticsLabel: 'down', width: 15, height: 15),
                  ],
                ),
              ),
              Visibility(
                  visible: visible,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Html(
                        data: item.value!,
                        style: {
                          "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                          "p": Style(
                              color: const Color(0xFF23262C),
                              fontSize: FontSize(14),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400
                          ),
                        },
                      ),
                    ],
                  )
              )
            ],
          )
      );
    });
  }
}