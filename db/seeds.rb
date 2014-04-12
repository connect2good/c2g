require Rails.root.join('spec', 'support', 'blueprints')
require 'faker'

%w(buyer seller beneficiary donor).each do |role|
  Role.create name: role
end

# Create Organizatons with Needs
Organization.make!(5).each do |organization|
  Need.make(10).each do |need|
    need.organization_id = organization.id
    need.save! validate: false
  end
end

# Create Individuals with sale_itmes
Individual.make!(5).each do |individual|
  Merchandise.make(10).each do |merchandise|
    merchandise.individual_id = individual.id
    merchandise.organization_id = Organization.all.sample.id
    merchandise.save! validate: false
  end
end


# Market Transactions
Purchase.make!(5).each do |purchase|
  # beneficiary
  beneficiary = Organization.all.sample

  # seller
  merchandise = Merchandise.all.sample
  seller      = merchandise.seller

  purchase.sale_item = merchandise

  # buyer
  begin
    buyer = Individual.all.sample
  end until buyer.id != seller.id

  purchase.buyer = buyer
  purchase.save! validate: false
end


# Donation Transaction
Donation.make!(5).each do |donation|
  # need
  need = Need.all.sample
  donation.need = need

  # beneficiary
  beneficiary = need.organization

  # donor
  donor = Individual.all.sample

  donation.donor = donor

  donation.save! validate: false
end
