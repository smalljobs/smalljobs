module Statistic
  class Dataset
    attr_reader :data

    def initialize data
      data = data
    end

    def call
      create_dataset
    end

    private

    def create_dataset
      labels, dataset = [], []
      data.map do |single_data|
        labels << single_data['date_interval']
        dataset << single_data['records_number']
      end
      {
          data: {
              labels: labels,
              dataset: [
                  {
                      label: 'Costam',
                      fill: false,
                      pointRadius: 4,
                      lineTension: 0,
                      borderWidth: 4,
                      borderColor: [
                        'rgba(255,0,0,1)'
                      ],
                      pointBackgroundColor: 'rgba(0,0,255,1)',
                      data: dataset
                  }
              ]
          }
      }
    end



    # data: {
    #     labels: ['January', 'February', 'March', 'April', 'May'],
    #     datasets: [
    #         {
    #             label: 'Organizatione',
    #             fill: false,
    #             pointRadius: 4,
    #             lineTension: 0,
    #             borderWidth: 4,
    #             borderColor: [
    #                 'rgba(255,0,0,1)'
    #             ],
    #             borderWidth:1,
    #             pointBackgroundColor: 'rgba(0,0,255,1)',
    #             data: ["#{@seekers}", "#{@providers}", "#{@assignments}", "#{@allocations}", "#{@jobs}"]
    #         }]
    # }





  end
end