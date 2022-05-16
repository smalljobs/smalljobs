module DefaultRulesText
  def providers_contract_text
    <<-HTML
<div class="font-bigger font-bold margin-top-40">
      Als Arbeitgeber_in stimme ich folgenden Bestimmungen zu:
    </div>
      <ol class="list-align-left">
        <li>
          Ich führe Jugendliche fachgerecht in sämtliche Arbeit an und beaufsichtige die Arbeit angemessen.
        </li>
        <li>
          Das Anstellungsverhältnis besteht direkt zwischen mir und dem Jugendlichen.
        </li>
        <li>
          Die vermittelnde Jobbörse kann unter keinen Umständen haftbar gemacht werden.
        </li>
        <li>
          Den Stundenlohn können Sie selbst bestimmen, wir empfehlen jedoch einen Richtwert
          von Alter x <%= @provider.organization.wage_factor || 1 %>
          (z.B. 17 Jahre x <%= @provider.organization.wage_factor || 1 %> =
          <%= 17 * (BigDecimal.new((@provider.organization.wage_factor || 1).to_s)) %> CHF)

<!--          Der Stundenlohn entspricht dem Alter des Jugendlichen mal <%#= @provider.organization.wage_factor || 1 %> (z.B. 17 Jahre-->
<!--          x <%#= @provider.organization.wage_factor || 1 %> = <%#= 17 * (@provider.organization.wage_factor || 1) %> CHF).-->
        </li>
        <li>
          Unfallversicherung: Familienversicherung des Jugendlichen (bis zu einem Jahreslohn von 750 CHF).
        </li>
        <li>
          Haftpflichtversicherung : Familienversicherung oder Arbeitgeberversicherung.
        </li>
        <li>
          Ausnahme für gewerbliche Arbeitgeber: Unfall-/Haftpflichtversicherung ist Sache des Arbeitgebers.
        </li>
        <li>
          Gemäss Jugendarbeitschutz sind für Jugendliche ab 13 Jahren in der Schweiz leichte
          Arbeiten im folgenden Rahmen erlaubt*:
        </li>
      </ol>

    <table border="1" cellpadding="0" cellspacing="0" style="border-collapse:collapse;" bordercolor="#cbe7d5" class="green-table">
    <thead>
    <tr>
      <th style="width: 65px;">
        Alter
      </th>
      <th style="width: 90px;">
        Arbeitszeiten
      </th>
      <th colspan="3"  style="width: 200px;">
        Max. täglich
      </th>
      <th colspan="2"  style="width: 150px;">
        Max. wöchentlich
      </th>
      <th>
        Verbotene Arbeiten
      </th>
    </tr>
    <tr class="second-row-table">
      <th></th>
      <th></th>
      <th style="width: 60px;">Mo–Fr</th>
      <th style="width: 30px;">Sa</th>
      <th>So</th>
      <th style="width: 70px;">Schulzeit</th>
      <th>Ferien</th>
      <th></th>
    </tr>
    </thead>
    <tbody>
    <tr>
      <td>
        16–18
      </td>
      <td>
        8–22 Uhr
      </td>
      <td>
        3h
      </td>
      <td>
        8h
      </td>
      <td>
        0h
      </td>
      <td>
        9h
      </td>
      <td>
        40h**
      </td>
      <td>
        Bedienung in Bars, Clubs, u.ä., gefährliche Arbeiten
      </td>
    </tr>
    <tr>
      <td>
        13–15
      </td>
      <td>
        8–18 Uhr
      </td>
      <td>
        3h
      </td>
      <td>
        8h
      </td>
      <td>
        0h
      </td>
      <td>
        9h
      </td>
      <td>
        40h**
      </td>
      <td>
        Kino, Zirkus, Bedienung von Gästen in Gastrobetrieben
      </td>
    </tr>
    </tbody>
  </table>
    <p class="small-stars">
      * Detailbestimmungen: www.smalljobs.ch/jugendschutz
      <br/>
      ** Maximal die halben Ferien lang
    </p>
    HTML
  end

  def contract_job_text
    <<-HTML
      <div class="font-bigger font-bold margin-top-40">
    Als Arbeitgeber/in stimme ich folgenden Bestimmungen zu:
  </div>
  <ol class="list-align-left">
    <li>
      Ich führe Jugendliche fachgerecht in sämtlichen Arbeiten an und beaufsichtige die Arbeit angemessen.
    </li>
    <li>
      Das Anstellungsverhältnis besteht direkt zwischen mir und dem/der Jugendlichen.
    </li>
    <li>
      Die vermittelnde Jobbörse kann unter keinen Umständen haftbar gemacht werden.
    </li>
   <!-- <li>
      Der Stundenlohn entspricht dem Alter des Jugendlichen mal <%= @provider&.organization&.wage_factor || 1 %> (z.B. 17 Jahre
      x <%= @provider&.organization&.wage_factor || 1 %> = <%= 17 * (@provider&.organization&.wage_factor || 1) %> CHF).
    </li>-->
    <li>
      Unfallversicherung: Familienversicherung des/der Jugendlichen (bis zu einem Jahreslohn von 750 CHF).
    </li>
    <li>
      Haftpflichtversicherung : Familienversicherung oder Arbeitgeberversicherung.
    </li>
    <li>
      Ausnahme für gewerbliche Arbeitgebende: Unfall-/Haftpflichtversicherung ist Sache des Arbeitgebers.
    </li>
    <li>
      Gemäss Jugendarbeitsschutz sind für Jugendliche ab 13 Jahren in der Schweiz leichte
      Arbeiten im folgenden Rahmen erlaubt*:
    </li>
  </ol>
  <table border="1" cellpadding="0" cellspacing="0" style="border-collapse:collapse;" bordercolor="#cbe7d5" class="green-table">
    <thead>
    <tr>
      <th style="width: 65px;">
        Alter
      </th>
      <th style="width: 90px;">
        Arbeitszeiten
      </th>
      <th colspan="3"  style="width: 200px;">
        Max. täglich
      </th>
      <th colspan="2"  style="width: 150px;">
        Max. wöchentlich
      </th>
      <th>
        Verbotene Arbeiten
      </th>
    </tr>
    <tr class="second-row-table">
      <th></th>
      <th></th>
      <th style="width: 60px;">Mo–Fr</th>
      <th style="width: 30px;">Sa</th>
      <th>So</th>
      <th style="width: 70px;">Schulzeit</th>
      <th>Ferien</th>
      <th></th>
    </tr>
    </thead>
    <tbody>
    <tr>
      <td>
        16–18
      </td>
      <td>
        8–22 Uhr
      </td>
      <td>
        3h
      </td>
      <td>
        8h
      </td>
      <td>
        0h
      </td>
      <td>
        9h
      </td>
      <td>
        40h**
      </td>
      <td>
        Bedienung in Bars, Clubs, u.ä., gefährliche Arbeiten
      </td>
    </tr>
    <tr>
      <td>
        13–15
      </td>
      <td>
        8–18 Uhr
      </td>
      <td>
        3h
      </td>
      <td>
        8h
      </td>
      <td>
        0h
      </td>
      <td>
        9h
      </td>
      <td>
        40h**
      </td>
      <td>
        Kino, Zirkus, Bedienung von Gästen in Gastrobetrieben
      </td>
    </tr>
    </tbody>
  </table>
  <p class="small-stars">
    * Detailbestimmungen: www.smalljobs.ch/jugendschutz
    <br/>
    ** Maximal die halben Ferien lang
  </p>
  <p>
    Bei Fragen und Unklarheiten stehen wir Ihnen gerne persönlich zur Verfügung.
  </p>
    HTML
  end
end